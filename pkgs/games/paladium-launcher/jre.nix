{ swingSupport ? true, lib, stdenv, requireFile, makeWrapper, unzip, file
, xorg ? null, pluginSupport ? true, glib, libxml2, ffmpeg, libxslt, libGL
, freetype, fontconfig, gtk2, pango, cairo, alsa-lib, atk, gdk-pixbuf
, setJavaClassPath }:

assert swingSupport -> xorg != null;

let

  #
  # The JRE libraries are in directories that depend on the CPU.
  architecture = "amd64";

  rSubPaths = [
    "lib/${architecture}/jli"
    "lib/${architecture}/server"
    "lib/${architecture}/xawt"
    "lib/${architecture}"
  ];

  java-source = stdenv.mkDerivation {
    name = "java-linux.tar.gz";
    src = requireFile {
      name = "java-linux.zip";
      url =
        "https://download.paladium-pvp.fr/games/bootstrap/java/java-linux.zip";
      sha256 = "sha256-kV/6QO6m1XKtQigdEyA8+adm9XsLu+oqsN3/+bVR6Vc=";
    };

    nativeBuildInputs = [ unzip ];

    unpackCmd = ''
      mkdir source
      (
        cd source;
        unzip $curSrc
      )
    '';

    buildPhase = ''
      find bin -exec echo Making {} executable \; -exec chmod +x {} \;
      find lib/amd64 -name '*.so' -exec echo Making {} executable \; -exec chmod +x {} \;
    '';

    installPhase = ''
      cd ..
      tar zcvf $out $sourceRoot
    '';

  };

in let
  result = stdenv.mkDerivation rec {
    pname = "paladium-jre";
    version = "1.8.0_202";

    src = java-source;

    nativeBuildInputs = [ file makeWrapper unzip ];

    # See: https://github.com/NixOS/patchelf/issues/10
    dontStrip = 1;

    installPhase = ''
      cd ..

      mv $sourceRoot $out

      shopt -s extglob
      for file in $out/!(*src.zip)
      do
        if test -f $file ; then
          rm $file
        fi
      done

      jrePath=$out

      mkdir $jrePath/lib/${architecture}/plugins
      ln -s $jrePath/lib/${architecture}/libnpjp2.so $jrePath/lib/${architecture}/plugins

      mkdir -p $out/nix-support
      printWords ${setJavaClassPath} > $out/nix-support/propagated-build-inputs

      # Set JAVA_HOME automatically.
      cat <<EOF >> $out/nix-support/setup-hook
      if [ -z "\''${JAVA_HOME-}" ]; then export JAVA_HOME=$out; fi
      EOF
    '';

    postFixup = ''
      rpath+="''${rpath:+:}${
        lib.concatStringsSep ":" (map (a: "$jrePath/${a}") rSubPaths)
      }"

      # set all the dynamic linkers
      find $out -type f -perm -0100 \
          -exec patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          --set-rpath "$rpath" {} \;

      find $out -name "*.so" -exec patchelf --set-rpath "$rpath" {} \;
    '';

    inherit pluginSupport;

    #
    # libXt is only needed on amd64
    libraries = [
      stdenv.cc.libc
      glib
      libxml2
      ffmpeg
      libxslt
      libGL
      xorg.libXxf86vm
      alsa-lib
      fontconfig
      freetype
      pango
      gtk2
      cairo
      gdk-pixbuf
      atk
    ] ++ lib.optionals swingSupport [
      xorg.libX11
      xorg.libXext
      xorg.libXtst
      xorg.libXi
      xorg.libXp
      xorg.libXt
      xorg.libXrender
      stdenv.cc.cc
    ];

    rpath = lib.strings.makeLibraryPath libraries;

    passthru.mozillaPlugin = "/lib/${architecture}/plugins";

    passthru.jre =
      result; # FIXME: use multiple outputs or return actual JRE package

    passthru.home = result;

    passthru.architecture = architecture;

    meta = with lib; {
      license = licenses.unfree;
      platforms = [
        "i686-linux"
        "x86_64-linux"
        "armv7l-linux"
        "aarch64-linux"
      ]; # some inherit jre.meta.platforms
      mainProgram = "java";
    };

  };
in result
