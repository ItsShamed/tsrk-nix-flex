# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, ... }:

{ config, pkgs, lib, ... }:

let
  mod = config.xsession.windowManager.i3.config.modifier;
  cfg = config.xsession.windowManager.i3.config;
  lockTargetsPresent = let targets = config.systemd.user.targets;
  in targets ? lock && targets ? sleep && targets ? unlock;
  lockCommand = if config.tsrk.i3.epitaRestrictions then
    "i3lock -i ${config.tsrk.i3.lockerBackground} -p win"
  else
    "${pkgs.betterlockscreen}/bin/betterlockscreen -l -- -p win";

  # TODO: figure how to disable services without them disappearing
  # I initially used `systemctl --user disable` so that if I ever need to run
  # other sessions, i3 user services would not pollute other window managers
  teardown = pkgs.writeShellScript "i3-teardown" (lib.strings.concatLines [
    ''
      # This script is responsible for stopping all services started with i3
      # and to stop i3
    ''
    (lib.strings.optionalString config.services.polybar.enable ''
      # Polybar
      systemctl --user stop polybar &
    '')
    (lib.strings.optionalString config.services.xsettingsd.enable ''
      # xsettingsd
      systemctl --user stop xsettingsd &
    '')
    (lib.strings.optionalString config.services.darkman.enable ''
      # darkman
      systemctl --user stop darkman &
    '')
    (lib.strings.optionalString config.tsrk.i3.useLogind ''
      # i3lock service
      # This service runs when the lock.target is reach and before sleeping
      systemctl --user stop i3lock &
    '')
    (lib.strings.optionalString config.programs.eww.enable ''
      # eww daemon
      (systemctl --user stop eww-mpris-watcher
      systemctl --user stop eww) &
    '')
    ''
      # Stop i3
      i3-msg exit
    ''
  ]);

  startup = pkgs.writeShellScript "i3-startup" (lib.strings.concatLines [
    ''
      ##
      # This script is responsible for (re)starting all services to be used with i3
      ##

    ''
    ''
      # Run the stored fehbg, so that we always have a background between
      # Sessions
      if [ -x "${config.home.homeDirectory}/.fehbg" ]; then
        "${config.home.homeDirectory}/.fehbg"
      fi
    ''
    ''
      ## Launch betterlockscreen setup
      systemctl --user start setup-betterlockscreen &
    ''
    (lib.strings.optionalString config.services.polybar.enable ''
      # Polybar
      if systemctl --user is-active polybar; then
        systemctl --user restart polybar &
      else
        systemctl --user enable --now polybar &
      fi
    '')
    (lib.strings.optionalString config.services.xsettingsd.enable ''
      # xsettingsd
      if systemctl --user is-active xsettingsd; then
        systemctl --user restart xsettingsd &
      else
        systemctl --user enable --now xsettingsd &
      fi

      (${pkgs.lxappearance}/bin/lxappearance &
      sleep 2
      ${pkgs.killall}/bin/killall .lxappearance-wrapped)&
    '')
    (lib.strings.optionalString config.services.darkman.enable ''
      # darkman
      if systemctl --user is-active darkman; then
        systemctl --user restart darkman &
      else
        systemctl --user enable --now darkman &
      fi
    '')
    (lib.strings.optionalString config.tsrk.i3.useLogind ''
      # i3lock service
      # This service runs when the lock.target is reached and before sleeping
      systemctl --user enable i3lock &
    '')
    (lib.strings.optionalString config.programs.eww.enable ''
      # eww daemon
      if systemctl --user is-active eww; then
        (
          systemctl --user stop eww-mpris-watcher
          systemctl --user restart eww
          systemctl --user start eww-mpris-watcher
        ) &
      else
        (
          systemctl --user enable --now eww
          systemctl --user enable --now eww-mpris-watcher
        ) &
      fi
    '')
  ]);

  teardownTarget = pkgs.writeShellScript "teardown-target" ''
    systemctl --user stop tray.target & disown
    systemctl --user stop x11-session.target & disown
    (loginctl terminate-session; i3-msg exit) & disown
  '';

  startupTarget = pkgs.writeShellScript "startup-target" ''
    if systemctl --user is-active x11-session.target; then
      systemctl --user restart x11-session.target & disown
      session_pid="$!"
    else
      systemctl --user enable --now x11-session.target & disown
      session_pid="$!"
    fi

    if systemctl --user is-active tray.target; then
      systemctl --user restart tray.target & disown
    else
      systemctl --user enable --now tray.target & disown
    fi
    ${lib.strings.optionalString config.services.darkman.enable ''

      # Restart Darkman, because otherwise the GTK theme is not set
      if systemctl --user is-active darkman; then
        systemctl --user restart darkman & disown
      else
        systemctl --user enable --now darkman & disown
      fi

    ''}
    waitpid $session_pid
    ${lib.strings.optionalString (config.systemd.user.services ? eww) ''

      # Restart eww because it won't pickup the compositor
      (
        systemctl --user restart eww${
          lib.strings.optionalString
          (config.systemd.user.services ? eww-starter) ''

            systemctl --user restart eww-starter
          ''
        }
      ) & disown
    ''}
  '';

  effectiveTeardown = if config.systemd.user.targets ? x11-session
  && config.systemd.user.targets ? tray then
    teardownTarget
  else
    teardown;

  effectiveStartup = if config.systemd.user.targets ? x11-session
  && config.systemd.user.targets ? tray then
    startupTarget
  else
    startup;

  volumeControl = pkgs.writeShellScript "volume-control" ''
    notifyVolume_() {
      volume="$(${pkgs.pamixer}/bin/pamixer --get-volume)"
      if [ "$(${pkgs.pamixer}/bin/pamixer --get-mute)" = "true" ]; then
        ${pkgs.libnotify}/bin/notify-send -a "tsrk-cirnos-nix-i3" "Volume" -h "int:value:$volume" -h string:synchronous:volume -u low " [Muted]"
      else
        ${pkgs.libnotify}/bin/notify-send -a "tsrk-cirnos-nix-i3" "Volume" -h "int:value:$volume" -h string:synchronous:volume -u low
      fi
    }

    increase() {
      if [ -n "$1" ]; then
        step="$1"
      else
        step=5
      fi
      ${pkgs.pamixer}/bin/pamixer -i "$step"
      notifyVolume_
    }

    decrease() {
      if [ -n "$1" ]; then
        step="$1"
      else
        step=5
      fi
      ${pkgs.pamixer}/bin/pamixer -d "$step"
      notifyVolume_
    }

    tmute() {
      ${pkgs.pamixer}/bin/pamixer -t
      notifyVolume_
    }

    case "$1" in
      increase|decrease|tmute)
        "$@"
        ;;
      *)
        echo "'$1' is not a valid command." >&2
        exit 1
        ;;
    esac
  '';

  brightnessControl = pkgs.writeShellScript "brightness-control" ''
    getBrightness_() {
      maxBrightness="$(${pkgs.brightnessctl}/bin/brightnessctl m)"
      curBrightness="$(${pkgs.brightnessctl}/bin/brightnessctl g)"
      ${pkgs.gawk}/bin/awk "BEGIN { print int(($curBrightness / $maxBrightness) * 100) }"
    }

    notifyBrightness_() {
      ${pkgs.libnotify}/bin/notify-send -a "tsrk-cirnos-nix-i3" "Brightness" -h "int:value:$(getBrightness_)" -h string:synchronous:brightness -u low
    }

    increase() {
      if [ -n "$1" ]; then
        step="$1"
      else
        step=5
      fi
      ${pkgs.brightnessctl}/bin/brightnessctl s +"$step"%
      notifyBrightness_
    }

    decrease() {
      if [ -n "$1" ]; then
        step="$1"
      else
        step=5
      fi
      ${pkgs.brightnessctl}/bin/brightnessctl s "$step"%-
      notifyBrightness_
    }

    case "$1" in
      increase|decrease)
        "$@"
        ;;
      *)
        echo "'$1' is not a valid command." >&2
        exit 1
        ;;
    esac
  '';

  i3Config = lib.mkIf config.tsrk.i3.enable {
    xsession.windowManager.i3 = {
      enable = true;
      config = {
        modifier = "Mod4";
        terminal = (self.lib.mkIfElse (config.programs.kitty.enable)
          (self.lib.mkGL config "kitty")
          # This is for the EPITA die-hards that never bothered to change their
          # default terminal emulator for their session lol
          (self.lib.mkGL config "${pkgs.alacritty}/bin/alacritty"));
        menu = (self.lib.mkIfElse (config.programs.rofi.enable)
          ''sh -c "rofi -show drun"'' "${pkgs.dmenu}/bin/dmenu_run");
        bars = [ ];

        startup = (lib.lists.optional (!config.services.darkman.enable) {
          command = "feh --bg-scale ${config.tsrk.i3.background}";
          always = false;
        }) ++ [{
          command = "sh ${effectiveStartup}";
          always = true;
          notification = false;
        }];

        window.titlebar = false;
        window.commands = [
          # Enable border for "normal" windows
          {
            command = "border pixel 2";
            criteria = { class = "^.*"; };
          }

          # Floating only for Pavucontrol
          {
            command = "floating enable";
            criteria = { class = "pavucontrol"; };
          }

          # Floating only for lxappearance
          {
            command = "floating enable";
            criteria = { class = ".xappearance"; };
          }

          {
            command = "floating enable";
            criteria = { window_role = "alert"; };
          }
        ];

        gaps = {
          outer = 5;
          inner = 5;
        };

        colors.focused = {
          border = lib.mkDefault "#edcb32";
          background = lib.mkDefault "#285577";
          text = lib.mkDefault "#ffffff";
          indicator = lib.mkDefault "#a0c20c";
          childBorder = lib.mkDefault "#edcb32";
        };

        colors.unfocused = {
          border = lib.mkDefault "#333333";
          background = lib.mkDefault "#222222";
          text = lib.mkDefault "#888888";
          indicator = lib.mkDefault "#edcb32";
          childBorder = lib.mkDefault "#222222";
        };

        keybindings = lib.mkDefault {
          # Basics

          "${mod}+Shift+q" = "kill";
          "${mod}+Return" = "exec ${cfg.terminal}";
          "${mod}+D" = "exec ${cfg.menu}";

          # Layouting

          "${mod}+Ctrl+h" = "split h";
          "${mod}+Ctrl+v" = "split v";
          "${mod}+f" = "fullscreen toggle";

          "${mod}+s" = "layout stacking";
          "${mod}+w" = "layout tabbed";
          "${mod}+e" = "layout toggle split";

          # Vim-like keybindings

          # focus change
          "${mod}+j" = "focus down";
          "${mod}+k" = "focus up";
          "${mod}+l" = "focus right";
          "${mod}+h" = "focus left";

          # window movement
          "${mod}+Shift+j" = "move down";
          "${mod}+Shift+k" = "move up";
          "${mod}+Shift+l" = "move right";
          "${mod}+Shift+h" = "move left";

          # Backup arrows

          # focus change
          "${mod}+Down" = "focus down";
          "${mod}+Up" = "focus up";
          "${mod}+Right" = "focus right";
          "${mod}+Left" = "focus left";

          # window movement
          "${mod}+Shift+Down" = "move down";
          "${mod}+Shift+Up" = "move up";
          "${mod}+Shift+Right" = "move right";
          "${mod}+Shift+Left" = "move left";

          # Floating windows
          "${mod}+space" = "focus mode_toggle";
          "${mod}+Shift+space" = "floating toggle";

          # Scratch pad
          "${mod}+minus" = "scratchpad show";
          "${mod}+Shift+minus" = "move scratchpad";

          # Autorandr

          "${mod}+p" = lib.mkIf config.services.autorandr.enable
            "exec systemctl --user restart autorandr";

          # Workspaces

          "${mod}+1" = "workspace number 1";
          "${mod}+2" = "workspace number 2";
          "${mod}+3" = "workspace number 3";
          "${mod}+4" = "workspace number 4";
          "${mod}+5" = "workspace number 5";
          "${mod}+6" = "workspace number 6";
          "${mod}+7" = "workspace number 7";
          "${mod}+8" = "workspace number 8";
          "${mod}+9" = "workspace number 9";
          "${mod}+0" = "workspace number 10";

          "${mod}+Shift+1" = "move container to workspace number 1";
          "${mod}+Shift+2" = "move container to workspace number 2";
          "${mod}+Shift+3" = "move container to workspace number 3";
          "${mod}+Shift+4" = "move container to workspace number 4";
          "${mod}+Shift+5" = "move container to workspace number 5";
          "${mod}+Shift+6" = "move container to workspace number 6";
          "${mod}+Shift+7" = "move container to workspace number 7";
          "${mod}+Shift+8" = "move container to workspace number 8";
          "${mod}+Shift+9" = "move container to workspace number 9";
          "${mod}+Shift+0" = "move container to workspace number 10";

          # Media keys
          XF86AudioRaiseVolume =
            ''exec --no-startup-id "${volumeControl} increase 5"'';
          XF86AudioLowerVolume =
            ''exec --no-startup-id "${volumeControl} decrease 5"'';
          XF86AudioMute = ''exec --no-startup-id "${volumeControl} tmute"'';
          XF86AudioPlay = ''
            exec --no-startup-id "${pkgs.playerctl}/bin/playerctl play-pause"'';
          XF86AudioPause = ''
            exec --no-startup-id "${pkgs.playerctl}/bin/playerctl play-pause"'';
          XF86AudioPrev = ''
            exec --no-startup-id "${pkgs.playerctl}/bin/playerctl previous" '';
          XF86AudioNext =
            ''exec --no-startup-id "${pkgs.playerctl}/bin/playerctl next" '';

          # Brightness
          XF86MonBrightnessUp =
            ''exec --no-startup-id "${brightnessControl} increase 2"'';
          XF86MonBrightnessDown =
            ''exec --no-startup-id "${brightnessControl} decrease 2"'';

          # lock
          "${mod}+i" =
            (self.lib.mkIfElse lockTargetsPresent "exec loginctl lock-session"
              ''exec "${lockCommand}"'');
          "${mod}+Shift+e" = config.tsrk.i3.exitPromptCommand effectiveTeardown;

          "${mod}+Shift+r" = "restart";
          "${mod}+Shift+c" = "reload";
          "${mod}+r" = ''mode "resize"'';
          "--release ${mod}+Shift+s" =
            (self.lib.mkIfElse config.services.flameshot.enable
              ''exec --no-startup-id "flameshot gui"'' ''
                exec --no-startup-id "${pkgs.scrot}/bin/scrot '/tmp/scrot-$a$Y%m%d%h%m%s.png' -s -e '${pkgs.xclip}/bin/xclip -selection clipboard -t image/png -i $f; rm $f'"'');
          "--release ${mod}+Print" =
            (self.lib.mkIfElse config.services.flameshot.enable
              ''exec --no-startup-id "flameshot full"'' ''
                exec --no-startup-id "${pkgs.scrot}/bin/scrot '/tmp/scrot-$a$Y%m%d%h%m%s.png' -e '${pkgs.xclip}/bin/xclip -selection clipboard -t image/png -i $f; rm $f'"'');
        };

        modes = {
          resize = {
            "h" = "resize shrink width 10 px or 10 ppt";
            "k" = "resize grow height 10 px or 10 ppt";
            "j" = "resize shrink height 10 px or 10 ppt";
            "l" = "resize grow width 10 px or 10 ppt";
            "r" = "mode default";
          };
        };
      };
    };

    specialisation = {
      light.configuration = {
        xsession.windowManager.i3.config = {
          colors.focused = {
            border = lib.mkForce "#3760bf";
            background = lib.mkForce "#e1e2e7";
            text = lib.mkForce "#3760bf";
            childBorder = lib.mkForce "#3760bf";
            indicator = lib.mkForce "#2496ac";
          };

          colors.focusedInactive = {
            border = lib.mkForce "#e1e2e7";
            background = lib.mkForce "#e1e2e7";
            text = lib.mkForce "#3760bf";
            childBorder = lib.mkForce "#e1e2e7";
            indicator = lib.mkForce "#3760bf";
          };

          colors.unfocused = {
            border = lib.mkForce "#e1e2e7";
            background = lib.mkForce "#e1e2e7";
            text = lib.mkForce "#3760bf";
            childBorder = lib.mkForce "#e1e2e7";
            indicator = lib.mkForce "#3760bf";
          };
        };
      };

      dark.configuration = {
        xsession.windowManager.i3.config = {
          colors.focused = {
            border = lib.mkForce "#c0caf5";
            background = lib.mkForce "#24283b";
            text = lib.mkForce "#c0caf5";
            childBorder = lib.mkForce "#c0caf5";
            indicator = lib.mkForce "#2496ac";
          };
          colors.focusedInactive = {
            border = lib.mkForce "#24283b";
            background = lib.mkForce "#24283b";
            text = lib.mkForce "#c0caf5";
            childBorder = lib.mkForce "#24283b";
            indicator = lib.mkForce "#c0caf5";
          };

          colors.unfocused = {
            border = lib.mkForce "#24283b";
            background = lib.mkForce "#24283b";
            text = lib.mkForce "#c0caf5";
            childBorder = lib.mkForce "#24283b";
            indicator = lib.mkForce "#c0caf5";
          };
        };
      };
    };

    systemd.user.services = {
      setup-betterlockscreen = lib.mkIf (!config.tsrk.i3.epitaRestrictions) {
        Install = {
          WantedBy =
            (self.lib.mkIfElse (config.systemd.user.targets ? x11-session)
              [ "x11-session.target" ] [ "graphical-session.target" ]);
        };

        Service = {
          Type = "oneshot";
          ExecStart =
            "${pkgs.betterlockscreen}/bin/betterlockscreen -u ${config.tsrk.i3.lockerBackground}";
        };
      };
    };
  };

  lockConfigs = [
    {
      services.screen-locker = {
        enable = lib.mkDefault true;
        xautolock.extraOptions = [
          "-notifier '${pkgs.libnotify}/bin/notify-send -a xautolock \"Auto-lock notice\" \"Computer will lock in 10 seconds\"'"
          "-notify 10"
        ];
      };
    }
    (lib.mkIf config.tsrk.i3.epitaRestrictions {
      services.screen-locker.lockCmd =
        "${pkgs.i3lock}/bin/i3lock -i ${config.tsrk.i3.lockerBackground} -p win";
      services.screen-locker.inactiveInterval = 1;
    })
    (lib.mkIf (!config.tsrk.i3.epitaRestrictions) {
      services.betterlockscreen = {
        enable = lib.mkDefault true;
        arguments = [ "--" "-p" "win" ];
        inactiveInterval = 1;
      };
    })
  ];
in {
  options = {
    tsrk.i3 = {
      enable = lib.options.mkEnableOption "tsrk's i3 configuration";
      lockerBackground = lib.options.mkOption {
        description = "Path to the background image for the locker.";
        type = lib.types.path;
        default = ./files/tehfire.png;
      };
      background = lib.options.mkOption {
        description = "Path to the main wallpaper background.";
        type = lib.types.path;
        default = ./files/bg-no-logo.png;
      };
      epitaRestrictions = lib.options.mkEnableOption ''
        compliance with EPITA
                regulations by using stock i3lock as the locker'';
      exitPromptCommand = lib.options.mkOption {
        description = "Command to execute when pressing the exit keybind.";
        type = lib.types.functionTo lib.types.str;
        default = teardown:
          ''
            exec " i3-nagbar -t warning -m 'Disconnect?' -b 'Yes' 'sh ${teardown}'"'';
      };
    };
  };

  config = lib.mkMerge ([ i3Config ] ++ lockConfigs);
}
