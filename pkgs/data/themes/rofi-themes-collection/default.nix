# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ fetchFromGitHub, stdenv, lib }:

stdenv.mkDerivation {
  pname = "rofi-themes-collection";
  version = "2024-06-27";

  src = fetchFromGitHub {
    owner = "newmanls";
    repo = "rofi-themes-collection";
    rev = "c8239a45edced3502894e1716a8b661fdea8f1c9";
    hash = "sha256-1F+qMwchTUWdEWpsIqyVG5pYmqdvmsCckvSmg7pYjdY=";
  };

  installPhase = ''
    rm -r screenshots
    mkdir -p $out
    mv themes/* $out
    mv * $out
  '';

  meta = with lib; {
    license = licenses.gpl3Plus;
    homepage = "https://github.com/newmanls/rofi-themes-collection";
    description = "Themes Collection for Rofi Launcher";
    platforms = platforms.linux;
  };
}
