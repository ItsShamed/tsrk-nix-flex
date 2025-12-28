# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.tsrk.kitty;
in
{
  options = {
    tsrk.kitty.enable = lib.options.mkEnableOption "kitty terminal emulator";
  };

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      package = config.lib.nixGL.wrap pkgs.kitty;
      font = lib.mkDefault {
        package = pkgs.nerd-fonts.iosevka-term;
        name = "IosevkaTerm Nerd Font";
      };

      themeFile = lib.mkDefault "tokyo_night_moon";

      shellIntegration = {
        enableBashIntegration = true;
        enableZshIntegration = true;
        enableFishIntegration = true;
      };
    };

    specialisation = {
      light.configuration = {
        programs.kitty.themeFile = lib.mkForce "tokyo_night_day";
      };
      dark.configuration = {
        programs.kitty.themeFile = lib.mkForce "tokyo_night_storm";
      };
    };

    home.activation.kitty-reload = lib.hm.dag.entryAfter [ "reloadSystemd" ] ''
      _i "Reloading kitty"
      if ! ${pkgs.killall}/bin/killall -USR1 .kitty-wrapped; then
        _iWarn "Failed to reload kitty, theme will not be updated"
      fi
    '';
  };

}
