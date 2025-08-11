# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ lib, fetchurl, corefonts, appimageTools, stdenvNoCC, makeWrapper, writeText }:

let
  pname = "unofficial-homestuck-collection";
  version = "2.7.0";

  src = fetchurl {
    url =
      "https://github.com/GiovanH/unofficial-homestuck-collection/releases/download/v${version}/The-Unofficial-Homestuck-Collection-${version}.AppImage";
    hash = "sha256-IfDEgKlRwAlpctiwL+lOTgBdSdUGFxCdArlu+dDiEcY=";
  };

  contents = appimageTools.extract { inherit pname version src; };

  fhsEnv = appimageTools.wrapType2 {
    inherit pname version src;

    extraPkgs = pkgs: [ pkgs.corefonts ];

    extraInstallCommands = ''
      mkdir -p $out/share/${pname}
      cp -a ${contents}/locales $out/share/${pname}
      cp -a ${contents}/resources $out/share/${pname}
      cp -a ${contents}/usr/share/icons $out/share
      install -Dm 644 ${contents}/unofficial-homestuck-collection.desktop -T $out/share/applications/unofficial-homestuck-collection.desktop

      substituteInPlace $out/share/applications/unofficial-homestuck-collection.desktop \
        --replace-fail "AppRun" "unofficial-homestuck-collection" \
        --replace-fail "Categories=game;" "Categories=Game;"
    '';
  };

in stdenvNoCC.mkDerivation {
  inherit pname version;

  src = fhsEnv;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -a * $out

    wrapProgram $out/bin/unofficial-homestuck-collection \
      --set FONTCONFIG_FILE ${
        writeText "fonts.conf" ''
          <?xml version="1.0" encoding="UTF-8"?>
          <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
          <fontconfig>
            <dir>${corefonts}</dir>
            <include ignore_missing="yes">${corefonts}/etc/fonts/conf.d</include>
            <include ignore_missing="yes">/etc/fonts/fonts.conf</include>
          </fontconfig>
        ''
      }

    runHook postInstall
  '';

  meta = with lib; {
    description = "An offline collection of Homestuck and its related works";
    homepage =
      "https://github.com/GiovanH/unofficial-homestuck-collection/tree/0ce7450ae02402669f671202718753cc75c95aae";
    license = with licenses; [
      gpl3 # The reader application (that we are fetching) is FOSS
      unfree # We are using corefonts, and Homestuck itself is not FOSS
    ];
    main = "unofficial-homestuck-collection";
    platforms = platforms.linux;
  };
}
