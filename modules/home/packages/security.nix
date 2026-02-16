# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.tsrk.packages.security;
in
{
  options = {
    tsrk.packages.security = {
      enable = lib.options.mkEnableOption "tsrk's security package bundle";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # YubiKey management
      yubikey-manager
      yubikey-personalization
      yubico-piv-tool
      yubioath-flutter

      # Bitwarden
      bitwarden-desktop
      bitwarden-cli

      # 2FA
      ente-auth

      keepassxc
    ];
  };
}
