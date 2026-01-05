# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  lib,
  stdenv,
  fetchFromGitHub,
  qtgraphicaleffects,
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
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "EricKotato";
    repo = "sddm-slice";
    rev = "1ddbc490a500bdd938a797e72a480f535191b45e";
    hash = "sha256-1AxRM2kHOzqjogYjFXqM2Zm8G3aUiRsdPDCYTxxQTyw=";
  };

  propagatedBuildInputs = [ qtgraphicaleffects ];

  dontWrapQtApps = true;

  preInstall = configureTheme;

  postInstall = ''
    mkdir -p $out/share/sddm/themes/slice

    cp -r . $out/share/sddm/themes/slice
  '';

  postFixup = ''
    mkdir -p $out/nix-support

    echo "${qtgraphicaleffects}" >> $out/nix-support/propagated-user-env-packages
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
