{ fetchFromBitbucket
, fetchurl
, fetchzip
, stdenv
, cmake
, python3
, jdk8
, git
, rsync
, lib
, ant
, ninja
, strip-nondeterminism
, stripJavaArchivesHook

, debugBuild ? false

, glib
, nss
, nspr
, atk
, at-spi2-atk
, libdrm
, expat
, libxcb
, libxkbcommon
, libX11
, libXt
, libXcomposite
, libXdamage
, libXext
, libXfixes
, libXrandr
, mesa
, gtk3
, pango
, cairo
, alsa-lib
, dbus
, at-spi2-core
, cups
, libxshmfence
, udev
}:

assert !stdenv.isDarwin;
# I can't test darwin

let
  rpath = lib.makeLibraryPath [
    glib
    nss
    nspr
    atk
    at-spi2-atk
    libdrm
    expat
    libxcb
    libxkbcommon
    libX11
    libXt
    libXcomposite
    libXdamage
    libXext
    libXfixes
    libXrandr
    mesa
    gtk3
    pango
    cairo
    alsa-lib
    dbus
    at-spi2-core
    cups
    libxshmfence
    udev
  ];

  buildType = if debugBuild then "Debug" else "Release";
  platform = {
    "aarch64-linux" = "linuxarm64";
    "x86_64-linux" = "linux64";
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  arches = {
    "linuxarm64" = {
      depsArch = "arm64";
      projectArch = "arm64";
      targetArch = "arm64";
    };
    "linux64" = {
      depsArch = "amd64";
      projectArch = "x86_64";
      targetArch = "x86_64";
    };
  }.${platform};
  inherit (arches) depsArch projectArch targetArch;

  buildMeta = builtins.fromJSON (builtins.readFile ./jcef_info.json);
in
stdenv.mkDerivation rec {
  pname = "jcef";
  inherit (buildMeta.nix) rev;
  # This is the commit number
  # Run `git rev-list --count HEAD`
  version = "309";

  nativeBuildInputs = [ cmake python3 jdk8 git rsync ant ninja strip-nondeterminism stripJavaArchivesHook ];
  buildInputs = [ libX11 libXt libXdamage nss nspr ];

  src = fetchFromBitbucket {
    inherit (buildMeta.nix) owner repo;
    inherit rev;
    hash = "sha256-OATgaV1ZTQ4sQ9E3qBz1JH9uCwZSxkF0Ns2EIDkW9nM=";
  };
  cef-bin =
    let
      # `cef_binary_${CEF_VERSION}_linux64_minimal`, where CEF_VERSION is from $src/CMakeLists.txt
      name = "cef_binary_${buildMeta.nix.cefBuild}_${platform}";
      hash = {
        "linuxarm64" = "sha256-gCDIfWsysXE8lHn7H+YM3Jag+mdbWwTQpJf0GKdXEVs=";
        "linux64" = "sha256-DhkqtNun16DUuoK+aCX7x4msAb+AvpKm6UCvHAErPjM=";
      }.${platform};
      urlName = builtins.replaceStrings [ "+" ] [ "%2B" ] name;
    in
    fetchzip {
      url = "https://cef-builds.spotifycdn.com/${urlName}.tar.bz2";
      inherit name hash;
    };
  clang-fmt = fetchurl {
    url = "https://storage.googleapis.com/chromium-clang-format/dd736afb28430c9782750fc0fd5f0ed497399263";
    hash = "sha256-4H6FVO9jdZtxH40CSfS+4VESAHgYgYxfCBFSMHdT0hE=";
  };

  configurePhase = ''
    runHook preConfigure

    patchShebangs .

    cp -r ${cef-bin} third_party/cef/${cef-bin.name}
    chmod +w -R third_party/cef/${cef-bin.name}
    patchelf third_party/cef/${cef-bin.name}/${buildType}/libcef.so --set-rpath "${rpath}" --add-needed libudev.so
    patchelf third_party/cef/${cef-bin.name}/${buildType}/chrome-sandbox --set-interpreter $(cat $NIX_BINTOOLS/nix-support/dynamic-linker)
    sed 's/-O0/-O2/' -i third_party/cef/${cef-bin.name}/cmake/cef_variables.cmake

    sed \
      -e 's|os.path.isdir(os.path.join(path, \x27.git\x27))|True|' \
      -e 's|"%s rev-parse %s" % (git_exe, branch)|"echo '${rev}'"|' \
      -e 's|"%s config --get remote.origin.url" % git_exe|"echo 'https://bitbucket.org/${buildMeta.nix.owner}/${buildMeta.nix.repo}'"|' \
      -e 's|"%s rev-list --count %s" % (git_exe, branch)|"echo '${version}'"|' \
      -i tools/git_util.py

    sed \
      -e 's|"''${DIR}"/tools/make_docs.sh||' \
      -e 's|python "''${DIR}"/tools/make_readme.py --output-dir "$DISTRIB_PATH/" --platform $DISTRIB_PLATFORM||' \
      -i tools/make_distrib.sh

    cp ${clang-fmt} tools/buildtools/linux64/clang-format
    chmod +w tools/buildtools/linux64/clang-format

    mkdir jcef_build
    cd jcef_build

    cmake -G "Ninja" -DPROJECT_ARCH="${projectArch}" -DCMAKE_BUILD_TYPE=${buildType} ..

    runHook postConfigure
  '';

  postBuild = ''
    export JCEF_ROOT_DIR=$(realpath ..)
    ../tools/compile.sh ${platform} Release
    ../tools/make_distrib.sh ${platform}
  '';

  installPhase = ''
    runHook preInstall

    export JCEF_ROOT_DIR=$(realpath ..)
    export OUT_NATIVE_DIR=$JCEF_ROOT_DIR/jcef_build/native/${buildType}
    export OUT_CLS_DIR=$(realpath ../out/${platform})
    export TARGET_ARCH=${targetArch} DEPS_ARCH=${depsArch}
    export OS=linux
    export JOGAMP_DIR="$JCEF_ROOT_DIR"/third_party/jogamp/jar
    export DISTRIB_PATH="$JCEF_ROOT_DIR/binary_distrib/${platform}"

    mkdir -p $out

    cp -ar "$DISTRIB_PATH"/bin/* $out

    runHook postInstall
  '';

  passthru = {
    inherit depsArch platform buildMeta;
  };

  dontFixup = true;
  dontStrip = debugBuild;

  meta = {
    description = "JCEF";
    license = lib.licenses.bsd3;
    homepage = "https://bitbucket.org/chromiumembedded/java-cef";
  };
}
