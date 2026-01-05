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
  cfg = config.tsrk.yubikey;
in
{
  options = {
    tsrk.yubikey = {
      enable = lib.options.mkEnableOption "YubiKey management programs and services";
    };
  };

  config = lib.mkIf cfg.enable {
    services.pcscd.enable = true;

    hardware.gpgSmartcards.enable = lib.mkDefault true;

    programs.yubikey-touch-detector = {
      enable = lib.mkDefault true;
      libnotify = lib.mkDefault true;
    };

    programs.gnupg.agent.settings = {
      default-cache-ttl = lib.mkDefault 60;
      max-cache-ttl = lib.mkDefault 120;
    };

    environment.systemPackages = with pkgs; [
      yubikey-manager
      yubikey-personalization
      yubico-piv-tool
      yubioath-flutter
    ];
  };
}
