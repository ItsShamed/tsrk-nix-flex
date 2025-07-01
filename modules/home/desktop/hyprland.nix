# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, ... }:

{ config, lib, pkgs, ... }:

let cfg = config.tsrk.hyprland;
in {
  options = {
    tsrk.hyprland = {
      enable = lib.options.mkEnableOption "tsrk's Hyprland configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = lib.mkDefault true;
      systemd.enable = lib.mkDefault true;
      settings = {
        general = {
          gaps_in = 5;
          gaps_out = 10;
          gaps_workspaces = 10;
          "col.inactive_border" = "rgb(24283b)";
          "col.active_border" = "rgb(c0caf5)";
          "col.nogroup_border" = "rgb(24283b)";
          "col.nogroup_border_active" = "rgb(c0caf5)";
          resize_on_border = true;
        };

        "$mainMod" = "SUPER";
        "$terminal" = (self.lib.mkIfElse (config.programs.kitty.enable)
          (self.lib.mkGL config "kitty")
          # This is for the EPITA die-hards that never bothered to change their
          # default terminal emulator for their session lol
          (self.lib.mkGL config "${pkgs.alacritty}/bin/alacritty"));

        decoration = {
          inactive_opacity = 0.75;
          shadow = {
            render_power = 2;
            color_inactive = "rgba(00000000)";
          };
        };

        input = {
          repeat_rate = 45;
          repeat_delay = 244;
          touchpad.natural_scroll = true;
        };

        group = {
          "col.border_inactive" = "rgb(24283b)";
          "col.border_active" = "rgb(c0caf5)";
        };

        bind = [ "$mainMod, Return, exec, $terminal" ];

        misc = {
          font_family = "IosevkaTerm Nerd Font";
          vrr = 2;
        };

        ecosystem = {
          no_update_news = true;
          no_donation_nag = true;
        };
      };
    };
  };
}
