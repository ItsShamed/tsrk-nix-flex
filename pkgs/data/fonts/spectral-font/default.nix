# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ stdenvNoCC, fetchFromGitHub, lib }:

stdenvNoCC.mkDerivation {
  pname = "spectral-font";
  version = "2.005";

  src = fetchFromGitHub {
    owner = "productiontype";
    repo = "Spectral";
    rev = "dbc06862d7030eedb1b01b60cdad8f6102f4ddfa";
    hash = "sha256-sEFJireK2KPA7fAJpibKM7XVUWm/SgJCHymhDGGLuko=";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/truetype/Spectral
    mkdir -p $out/share/fonts/opentype/Spectral

    find fonts/ttf -name '*.ttf' \
      -exec cp {} $out/share/fonts/truetype/Spectral \;
    find fonts/otf -name '*.otf' \
      -exec cp {} $out/share/fonts/opentype/Spectral \;
  '';

  meta = with lib; {
    description =
      "Original typeface, primarily intended for use inside Google's Docs and Slides";
    homepage = "https://productiontype.com/font/spectral";
    license = licenses.ofl;
  };
}
