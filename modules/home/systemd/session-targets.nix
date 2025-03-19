# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ config, lib, pkgs, ... }:

{
  key = ./.;

  options = {
    tsrk.sessionTargets.enable =
      lib.options.mkEnableOption "tsrk's session targets";
  };

  config = lib.mkIf config.tsrk.sessionTargets.enable {
    home.packages = with pkgs; [ systemd-lock-handler ];
    systemd.user.targets = {
      x11-session = {
        Unit = {
          Description = "Current X11 Graphical Session";
          ConditionEnvironment =
            [ "|XDG_SESSION_TYPE=x11" "|!WAYLAND_DISPLAY=" ];
          Conflicts = "wayland-session.target";
          After = [ "graphical-session-pre.target" ];
          PartOf = [ "graphical-session.target" ];
          BindsTo = "graphical-session.target";
        };
      };
      wayland-session = {
        Unit = {
          Description = "Current Wayland Graphical Session";
          ConditionEnvironment =
            [ "|XDG_SESSION_TYPE=wayland" "|WAYLAND_DISPLAY=" ];
          Conflicts = "x11-session.target";
          After = [ "graphical-session-pre.target" ];
          PartOf = [ "graphical-session.target" ];
          BindsTo = "graphical-session.target";
        };
      };
      tray = {
        Unit = {
          Description = "Current System Tray display";
          After = [ "graphical-session-pre.target" ];
          PartOf = [ "graphical-session.target" ];
          Bindsto = "graphical-session.target";
        };
      };
      lock = {
        Unit = {
          Conflicts = "unlock.target";
          Description = "Lock the current session";
        };
      };
      unlock = {
        Unit = {
          Conflicts = "lock.target";
          Description = "Unlocks the current session";
        };
      };
      sleep = {
        Unit = {
          Description =
            "User-level target triggered when the system is about to sleep.";
          Requires = "lock.target";
          After = "lock.target";
        };
      };
    };

    systemd.user.services = {
      systemd-lock-handler = {
        Unit = {
          Description = "Logind lock event to systemd target translation";
          Documentation = "https://sr.ht/~whynothugo/systemd-lock-handler";
        };

        Service = {
          Slice = "session.slice";
          ExecStart = "${pkgs.systemd-lock-handler}/lib/systemd-lock-handler";
          Type = "notify";
          Restart = "on-failure";
          RestartSec = "10s";
        };

        Install = { WantedBy = [ "default.target" ]; };
      };

      dunst = lib.mkIf config.services.dunst.enable {
        Unit = {
          PartOf = lib.mkForce [ "x11-session.target" ];
          ConditionEnvironment =
            [ "|XDG_SESSION_TYPE=x11" "|!WAYLAND_DISPLAY=" ];
        };
      };
      picom = lib.mkIf config.services.picom.enable {
        Install.WantedBy = lib.mkForce [ "x11-session.target" ];
        Unit.PartOf = lib.mkForce [ "x11-session.target" ];
      };
      polybar = lib.mkIf config.services.polybar.enable {
        Unit.ConditionEnvironment =
          [ "|XDG_SESSION_TYPE=x11" "|!WAYLAND_DISPLAY=" ];
      };
      xsettingsd = lib.mkIf config.services.xsettingsd.enable {
        Install.WantedBy = lib.mkForce [ "x11-session.target" ];
        Unit.PartOf = lib.mkForce [ "x11-session.target" ];
      };
      xss-lock = lib.mkIf config.services.screen-locker.enable {
        Install.WantedBy = lib.mkForce [ "x11-session.target" ];
        Unit.PartOf = lib.mkForce [ "x11-session.target" ];
      };
      xautolock-session =
        lib.mkIf config.services.screen-locker.xautolock.enable {
          Unit.PartOf = lib.mkForce [ "x11-session.target" ];
        };
    };
  };
}
