{ lib
, makeDesktopItem
, symlinkJoin
, makeWrapper
, fetchurl
, callPackage
, stdenvNoCC
, openjdk8
, unzip
, zip
}:

let
  info = builtins.fromJSON (builtins.readFile ./info.json);
  pname = "paladium-launcher";

  jcef = callPackage ./jcef.nix { };

  paladium-launcher = stdenvNoCC.mkDerivation {
    inherit (info) version;
    inherit pname;

    nativeBuildInputs = [ makeWrapper unzip zip ];

    src = fetchurl {
      inherit (info) url;
      name = "${pname}.jar";
      sha256 = info.hash;
    };

    unpackCmd = ''
      mkdir launcher
      (
        cd launcher;
        unzip $curSrc
      )
    '';

    sourceRoot = "launcher";

    outputs = [ "out" "packed" ];

    buildPhase = ''
      mkdir $packed
      srcRoot="$(pwd)"
      (
        cd ${jcef}/lib/${jcef.platform};
        tar zcvf "$srcRoot"/jcef-natives-linux-${jcef.depsArch}-${jcef.buildMeta.release_tag}.tar.gz *
      )
      zip -v -r $packed/paladium-launcher.jar .
    '';

    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/share/java

      cp -a $packed/paladium-launcher.jar $out/share/java

      makeWrapper ${openjdk8}/bin/java $out/bin/paladium-launcher \
        --add-flags "-cp $out/share/java/paladium-launcher.jar fr.paladium.Launcher" \
        --add-flags "-Djavax.net.ssl.trustStore=${./truststore.jks}"
    '';
  };

  desktopItem = makeDesktopItem {
    name = pname;
    exec = "${paladium-launcher}/bin/paladium-launcher %U";
    desktopName = "Paladium Launcher";
    categories = [ "Game" ];
  };
in
symlinkJoin {
  name = pname;
  paths = [
    paladium-launcher
    desktopItem
  ];

  meta = with lib; {
    description = "Minecraft Launcher for the Paladium modded server.";
    homepage = "https://paladium-pvp.fr";
    license = licenses.unfree;
    passthru.updateScript = ./update.sh;
    platforms = platforms.linux;
  };
}
