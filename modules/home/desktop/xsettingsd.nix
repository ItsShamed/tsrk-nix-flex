# Copyright (c) 2024 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ config, lib, pkgs, ... }:

let cfg = config.tsrk.xsettingsd;
in {
  options = {
    tsrk.xsettingsd = { enable = lib.options.mkEnableOption "xsettingsd"; };
  };

  config = lib.mkIf cfg.enable {
    home.pointerCursor = {
      gtk.enable = lib.mkDefault true;
      x11.enable = lib.mkDefault true;
      package = pkgs.apple-cursor;
      name = "macOS";
    };

    services.xsettingsd = {
      enable = true;
      settings = {
        "Xft/Antialias" = 1;
        "Xft/HintStyle" = "hintfull";
        "Xft/Hinting" = 1;
        "Xft/RGBA" = "rgb";
        "Gtk/CursorThemeName" = "macOS";
        "Gtk/CursorThemeSize" = 32;
        "Xcursor/size" = 32;
      };
    };

    home.packages = with pkgs;
      [
        (tokyonight-gtk-theme.override {
          colorVariants = [ "dark" "light" ];
          tweakVariants = [ "storm" ];
          iconVariants = [ "Dark" "Light" ];
        })
      ];

    specialisation = {
      light.configuration = {
        services.xsettingsd.settings."Net/ThemeName" = "Tokyonight-Light-Storm";
        services.xsettingsd.settings."Net/IconThemeName" = "Tokyonight-Light";
      };
      dark.configuration = {
        services.xsettingsd.settings."Net/ThemeName" = "Tokyonight-Dark-Storm";
        services.xsettingsd.settings."Net/IconThemeName" = "Tokyonight-Dark";
      };
    };

    home.activation.xsettingsd-reload =
      lib.hm.dag.entryAfter [ "reloadSystemd" ] ''
        _i "Reloading xsettingsd"

        {
          # This will crash if this is running at boot (no graphical environment)
          ${config.systemd.user.systemctlPath} --user restart xsettingsd
          ${lib.meta.getExe pkgs.lxappearance}&
          sleep 1
          ${lib.meta.getExe pkgs.killall} .lxappearance-wrapped
        } || true
      '';
  };
}
