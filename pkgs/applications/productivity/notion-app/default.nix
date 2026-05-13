# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  callPackage,
  notion-bin ? callPackage ./notion-bin.nix { },
  symlinkJoin,
  makeDesktopItem,
  lib,
}:

let
  desktopItem = makeDesktopItem {
    name = "notion";
    desktopName = "Notion";
    genericName = "Online Document Editor";
    comment = "Your connected workspace for wiki, docs & projects";
    exec = "${notion-bin}/bin/notion-app %U";
    icon = "notion";
    categories = [ "Office" ];
    mimeTypes = [ "x-scheme-handler/notion" ];
  };
in
symlinkJoin {
  pname = "notion-app";
  version = "7.17.0";

  paths = [
    notion-bin
    desktopItem
  ];

  meta = {
    description = "Your connected workspace for wiki, docs & projects";
    homepage = "https://notion.so";
    mainProgram = "notion-app";
    license = lib.licenses.unfreeRedistributable;
    platforms = lib.platforms.linux;
  };

  passthru = {
    inherit notion-bin;
  };
}
