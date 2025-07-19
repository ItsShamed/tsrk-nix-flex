# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ config, lib, pkgs, ... }:

let cfg = config.tsrk.xsettingsd;
in {
  options = {
    tsrk.xsettingsd = {
      enable = lib.options.mkEnableOption "xsettingsd";
      withDConf =
        lib.options.mkEnableOption "configuring DConf alongside xsettingsd";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
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
          "Gtk/CursorThemeSize" = 48;
          "Xcursor/size" = 48;
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
          services.xsettingsd.settings."Net/ThemeName" =
            "Tokyonight-Light-Storm";
          services.xsettingsd.settings."Net/IconThemeName" = "Tokyonight-Light";
        };
        dark.configuration = {
          services.xsettingsd.settings."Net/ThemeName" =
            "Tokyonight-Dark-Storm";
          services.xsettingsd.settings."Net/IconThemeName" = "Tokyonight-Dark";
        };
      };

      home.activation.xsettingsd-reload =
        lib.hm.dag.entryAfter [ "reloadSystemd" ] ''
          if [ "''${XDG_SESSION_TYPE:-}" != "x11" ] || [ -n "''${WAYLAND_DISPLAY:-}" ]; then
            ${config.systemd.user.systemctlPath} --user restart xsettingsd || true
            _i "X11 is not running, not applying theme with LXAppearance"
          else
            _i "Reloading xsettingsd"

            {
              # This will crash if this is running at boot (no graphical environment)
              ${config.systemd.user.systemctlPath} --user restart xsettingsd
              ${lib.meta.getExe pkgs.lxappearance}&
              sleep 1
              ${lib.meta.getExe pkgs.killall} .lxappearance-wrapped
            } || true
          fi
        '';
    }
    (lib.mkIf cfg.withDConf {
      dconf.settings = {
        "org/gnome/desktop/interface" = {
          cursor-size = 48;
          cursor-theme = "macOS-BigSur";
        };
      };

      specialisation = {
        light.configuration = {
          dconf.settings."org/gnome/desktop/interface" = {
            color-scheme = "prefer-light";
            gtk-theme = "Tokyonight-Light-Storm";
          };

          home.activation.dconfSettings-lightfix =
            lib.hm.dag.entryAfter [ "xsettingsd-reload" ] ''
              if [[ -v DBUS_SESSION_BUS_ADDRESS ]]; then
                export DCONF_DBUS_RUN_SESSION=""
              else
                export DCONF_DBUS_RUN_SESSION="${pkgs.dbus}/bin/dbus-run-session --dbus-daemon=${pkgs.dbus}/bin/dbus-daemon"
              fi

              run $DCONF_DBUS_RUN_SESSION ${
                lib.meta.getExe pkgs.dconf
              } write /org/gnome/desktop/interface/gtk-theme "'bogus'"
              run $DCONF_DBUS_RUN_SESSION ${
                lib.meta.getExe pkgs.dconf
              } write /org/gnome/desktop/interface/gtk-theme "'Tokyonight-Light-Storm'"

              unset DCONF_DBUS_RUN_SESSION
            '';
        };
        dark.configuration = {
          dconf.settings."org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            gtk-theme = "Tokyonight-Dark-Storm";
          };
        };
      };
    })
  ]);
}
