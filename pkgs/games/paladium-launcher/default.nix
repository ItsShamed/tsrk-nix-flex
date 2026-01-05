# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  lib,
  makeDesktopItem,
  symlinkJoin,
  makeWrapper,
  fetchurl,
  callPackage,
  stdenvNoCC,
  unzip,
  zip,
}:

let
  info = builtins.fromJSON (builtins.readFile ./info.json);
  pname = "paladium-launcher";

  jcef = callPackage ./jcef.nix { };
  jre-paladium = callPackage ./jre.nix { };

  paladium-launcher = stdenvNoCC.mkDerivation {
    inherit (info) version;
    inherit pname;

    nativeBuildInputs = [
      makeWrapper
      unzip
      zip
    ];

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

    outputs = [
      "out"
      "packed"
    ];

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

      makeWrapper ${jre-paladium}/bin/java $out/bin/paladium-launcher \
        --add-flags "-cp $out/share/java/paladium-launcher.jar fr.paladium.Launcher" \
        --add-flags "-Djavax.net.ssl.trustStore=${./truststore.jks}" \
        --add-flags "'-Djavax.net.ssl.trustStorePassword=01pG^{QV(*6j'" \
        --add-flags "-Djavax.net.ssl.keyStore=${./truststore.jks}" \
        --add-flags "'-Djavax.net.ssl.keyStorePassword=01pG^{QV(*6j'" \
        --add-flags "-Djavax.net.debug=all"
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
    broken = true;
  };
}
