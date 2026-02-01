# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  themeConfig ? { },
}:
let
  configureTheme = ''
    cat <<EOF > theme.conf.user
    ${lib.generators.toINI { } { General = themeConfig; }}
    EOF
  '';
in
stdenv.mkDerivation {
  pname = "sddm-slice-theme";
  version = "1.5.1+4";

  src = fetchFromGitHub {
    owner = "EricKotato";
    repo = "sddm-slice";
    rev = "98996b49e0d5657f94cc0cfb71480da76c83b008";
    hash = "sha256-+SgHhOXl/HpW3xsvfPVYH4uEQ8/J7G23ThCCaIw/29Y=";
  };

  patches = [
    ./0001-drop-qt5-support.patch
  ];

  dontWrapQtApps = true;

  preInstall = configureTheme;

  postInstall = ''
    mkdir -p $out/share/sddm/themes/slice

    cp -r . $out/share/sddm/themes/slice
  '';

  meta = with lib; {
    license = licenses.cc-by-sa-20;
    homepage = "https://github.com/EricKotato/sddm-slice";
    description = "Simple dark SDDM theme with many customization options.";
    platforms = platforms.linux;
  };
}
// {
  withConfig = config: callPackage ./. { themeConfig = themeConfig // config; };
}
