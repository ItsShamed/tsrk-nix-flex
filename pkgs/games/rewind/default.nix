# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  lib,
  fetchurl,
  appimageTools,
  symlinkJoin,
  makeDesktopItem,
}:

let
  pname = "rewind";
  version = "0.2.2";

  appimageBin = fetchurl {
    url = "https://github.com/abstrakt8/rewind/releases/download/v${version}/Rewind-${version}.AppImage";
    hash = "sha256-2SfrmP/Y3JrQeYn06vvjKRUrHb2p0SqSB7w18/ybbeg=";
  };

  extracted = appimageTools.extract {
    inherit version;
    pname = "Rewind.AppImage";
    src = appimageBin;
  };

  package = appimageTools.wrapType2 {
    inherit pname version;

    src = appimageBin;
    extraPkgs =
      pkgs: with pkgs; [
        mesa
        libGLU
      ];
  };

  desktopItem = makeDesktopItem {
    name = "rewind";
    exec = "${package}/bin/rewind %U";
    icon = "${extracted}/rewind.png";
    desktopName = "Rewind";
    startupWMClass = "Rewind";
    terminal = false;
    categories = [ "Utility" ];
  };
in
symlinkJoin {
  name = "${pname}-bin-${version}";
  paths = [
    package
    desktopItem
  ];

  meta = with lib; {
    description = "A beatmap/replay analyzer for the rhythm game called osu!";
    homepage = "https://github.com/abstrakt8/rewind";
    license = licenses.mit;
    mainProgram = "rewind";
    platforms = platforms.unix;
  };
}
