# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ lib, fetchurl, appimageTools, symlinkJoin, makeDesktopItem }:

let
  pname = "realm-studio";
  version = "15.2.1";

  appimageBin = fetchurl {
    url =
      "https://static.realm.io/downloads/realm-studio/Realm%20Studio-${version}.AppImage";
    hash = "sha256-e3uUyxGdurQv++YFqEJWiLpKfxN9DJa7QTSumjcJJpA=";
  };

  extracted = appimageTools.extract {
    inherit pname version;
    src = appimageBin;
  };

  package = appimageTools.wrapType2 rec {
    inherit pname version;
    src = appimageBin;
  };

  desktopItem = makeDesktopItem {
    name = pname;
    exec = "${package}/bin/realm-studio --no-sandbox %U";
    icon = "${extracted}/usr/share/icons/hicolor/0x0/apps/realm-studio.png";
    desktopName = "Realm Studio";
    startupWMClass = "Realm Studio";
    terminal = false;
    categories = [ "Development" ];
  };
in symlinkJoin {
  name = "${pname}-bin-${version}";
  paths = [ package desktopItem ];

  meta = with lib; {
    description = "Visual tool to view, edit, and model Realm databases.";
    homepage = "https://www.mongodb.com/docs/atlas/device-sdks/studio/";
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
