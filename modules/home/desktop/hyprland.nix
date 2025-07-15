# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, ... }:

{ config, lib, pkgs, ... }:

let
  cfg = config.tsrk.hyprland;
  mkNumberBinds = mod: keywordFn:
    (builtins.foldl' (c: e: c ++ [ "${mod}, ${e}, ${keywordFn e}" ]) [ ]
      (builtins.genList (x: builtins.toString (x + 1)) 9))
    ++ [ "${mod}, 0, ${keywordFn "0"}" ];
  lockTargetsPresent = let targets = config.systemd.user.targets;
  in targets ? lock && targets ? sleep && targets ? unlock;

  mkSubMap = name: attrs: ''
    submap = ${name}
    ${lib.hm.generators.toHyprconf {
      inherit attrs;
      indentLevel = 1;
    }}
    submap = reset
  '';

  submapsToHyprConf = lib.concatMapAttrsStringSep "\n" mkSubMap;

  volumeControl = pkgs.writeShellScript "volume-control" ''
    notifyVolume_() {
      volume="$(${pkgs.pamixer}/bin/pamixer --get-volume)"
      if [ "$(${pkgs.pamixer}/bin/pamixer --get-mute)" = "true" ]; then
        ${pkgs.libnotify}/bin/notify-send -a "tsrk-cirnos-nix-hypr" "Volume" -h "int:value:$volume" -h string:synchronous:volume -u low " [Muted]"
      else
        ${pkgs.libnotify}/bin/notify-send -a "tsrk-cirnos-nix-hypr" "Volume" -h "int:value:$volume" -h string:synchronous:volume -u low
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
      ${pkgs.libnotify}/bin/notify-send -a "tsrk-cirnos-nix-hypr" "Brightness" -h "int:value:$(getBrightness_)" -h string:synchronous:brightness -u low
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

  snipTool = if config.services.flameshot.enable then
    "flameshot gui"
  else
    with lib.meta;
    ''
      ${getExe pkgs.grim} -g "$(${
        getExe pkgs.slurp
      })" - | ${pkgs.wl-clipboard}/bin/wl-copy'';

  scTool = if config.services.flameshot.enable then
    "flameshot full"
  else
    "${lib.meta.getExe pkgs.grim} - | ${pkgs.wl-clipboard}/bin/wl-copy";

  logout = pkgs.writeShellScript "terminate-session-wrapper" ''
    if command -v uwsm >/dev/null; then
      uwsm stop
    else
      loginctl terminate-session "$XDG_SESSION_ID"
    fi
  '';
in {
  key = ./hyprland.nix;

  imports = with self.homeManagerModules; [ session-targets ];

  options = {
    tsrk.hyprland = {
      enable = lib.options.mkEnableOption "tsrk's Hyprland configuration";
      # TODO: Deprecate when https://github.com/nix-community/home-manager/pull/7277
      # is merged
      submaps = lib.options.mkOption {
        description = ''
          Attribute set of Hyprland submaps

          See <https://wiki.hypr.land/Configuring/Binds#submaps> to learn about submaps
        '';
        default = { };
        type = with lib.types;
          attrsOf
          ((attrsOf (listOf str)) // { description = "Hyprland binds"; });
      };
      backgrounds = {
        lockscreen = lib.options.mkOption {
          description = "Image to use as the lockscreen background";
          type = lib.types.path;
          default = ./files/tehfire.png;
        };
        default = lib.options.mkOption {
          description =
            "Image to use as the default backgroud (when Darkman is disabled)";
          type = lib.types.path;
          default = ./files/bg-no-logo.png;
        };
        light = lib.options.mkOption {
          description =
            "Image to use as a light-theme background (needs Darkman)";
          type = lib.types.path;
          default = ./files/torekka.png;
        };
        dark = lib.options.mkOption {
          description =
            "Image to use as a dark-themed background (needs Darkman)";
          type = lib.types.path;
          default = ./files/bg-no-logo.png;
        };
      };
      darkman = {
        enable = lib.options.mkEnableOption "Darkman intergration" // {
          default = config.services.darkman.enable;
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [{
      assertion = !builtins.hasAttr "reset" cfg.submaps;
      message = "Submaps can't be named 'reset'.";
    }];

    tsrk.sessionTargets.enable = lib.mkDefault true;
    wayland.systemd.target = lib.mkDefault "hyprland-session.target";

    programs.hyprlock = {
      enable = lib.mkDefault true;
      settings = {
        general = { ignore_empty_input = true; };

        background.path = "${cfg.backgrounds.lockscreen}";

        shape = {
          color = "rgba(0, 0, 0, 0.75)";
          rounding = 0;
          size = "350, 110";
          position = "30, 30";
          halign = "bottom";
          valign = "left";
        };

        label = [
          {
            text = "cmd[update:500] date +'%H:%M:%S'";
            font_size = 24;
            font_family = "$font";

            position = "50, 87";
            halign = "left";
            valign = "bottom";
          }
          {
            text = "cmd[update:60000] date +'%A, %d %B %Y'";
            font_size = 14;
            font_family = "$font";

            position = "50, 63";
            halign = "bottom";
            valign = "left";
          }
        ];

        input-field = {
          position = "30, 30";
          size = "350, 33";
          rounding = 0;
          outline_thickness = 0;
          fade_on_empty = 0;
          dots_center = false;
          halign = "left";
          fail_color = "rgba(00000000)";
          check_color = "rgba(00000000)";
          valign = "bottom";
          outer_color = "rgba(00000000)";
          inner_color = "rgba(00000000)";
          font_color = "rgba(ffffffff)";
          placeholder_text = "Type password to unlock...";
        };
      };
    };

    services.hyprpaper = {
      enable = lib.mkDefault true;
      settings = {
        preload = [
          "${cfg.backgrounds.light}"
          "${cfg.backgrounds.dark}"
          "${cfg.backgrounds.default}"
        ];

        wallpaper = [ ", ${cfg.backgrounds.default}" ];
      };
    };

    services.darkman = lib.mkIf cfg.darkman.enable {
      lightModeScripts.hyprpaper = ''
        if [ "''${XDG_SESSION_TYPE:-}" = "wayland" ] && [ -n "''${WAYLAND_DISPLAY:-}" ]; then
          hyprctl hyprpaper reload ,"${cfg.backgrounds.light}"
        else
          echo "Not running Wayland, skipping hyprpaper" >&2
        fi
      '';
      darkModeScripts.hyprpaper = ''
        if [ "''${XDG_SESSION_TYPE:-}" = "wayland" ] && [ -n "''${WAYLAND_DISPLAY:-}" ]; then
          hyprctl hyprpaper reload ,"${cfg.backgrounds.dark}"
        else
          echo "Not running Wayland, skipping hyprpaper" >&2
        fi
      '';
    };

    services.hypridle = {
      enable = lib.mkDefault true;
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          before_sleep_cmd = "loginctl lock-session";
          lock_cmd = "${pkgs.procps}/bin/pidof hyprlock || hyprlock";
        };

        listener = [
          {
            timeout = 150;
            on-timeout = "${lib.meta.getExe pkgs.brightnessctl} -s 25%-";
            on-resume = "${lib.meta.getExe pkgs.brightnessctl} -r";
          }
          {
            timeout = 290;
            on-timeout =
              "${pkgs.libnotify}/bin/notify-send -a hypridle 'Auto-lock notice' 'Computer will lock in 10 seconds'";
          }
          {
            timeout = 300;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 150;
            on-timeout = "${lib.meta.getExe pkgs.brightnessctl} -s 25%-";
            on-resume = "${lib.meta.getExe pkgs.brightnessctl} -r";
          }
          {
            timeout = 500;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };

    wayland.windowManager.hyprland = {
      enable = lib.mkDefault true;
      systemd.enable = lib.mkDefault true;
      settings = {
        general = {
          border_size = 2;
          gaps_in = 5;
          gaps_out = 10;
          gaps_workspaces = 10;
          resize_on_border = true;
        };

        "$mainMod" = "SUPER";
        "$terminal" = (self.lib.mkIfElse (config.programs.kitty.enable)
          (self.lib.mkGL config "kitty")
          # This is for the EPITA die-hards that never bothered to change their
          # default terminal emulator for their session lol
          (self.lib.mkGL config "${pkgs.alacritty}/bin/alacritty"));
        "$menu" =
          (self.lib.mkIfElse (config.programs.rofi.enable) "rofi -show drun"
            "${pkgs.bemenu}/bin/bemenu-run");

        decoration = {
          rounding = 10;
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

        # Needed to propagate necessary envvars to darkman
        execr-once = (lib.lists.optional cfg.darkman.enable
          "systemctl --user restart darkman");

        bindd = [
          "$mainMod, Return, Open terminal emulator, exec, $terminal"
          "$mainMod SHIFT, Q, Kill active window, killactive"
          "$mainMod, D, Open Menu, exec, $menu"

          "$mainMod, F, Toggle fullscreen on active window, fullscreen, 0"
          "$mainMod SHIFT, F, Toggle maximizing active window, fullscreen, 1"

          # Vim-like keybindings
          # focus
          "$mainMod, H, Move focus left (Vim),  movefocus, l"
          "$mainMod, L, Move focus right (Vim), movefocus, r"
          "$mainMod, K, Move focus up (Vim),    movefocus, u"
          "$mainMod, J, Move focus down (Vim),  movefocus, d"
          # move
          "$mainMod SHIFT, H, Move active window left (Vim),  movewindow, l"
          "$mainMod SHIFT, L, Move active window right (Vim), movewindow, r"
          "$mainMod SHIFT, K, Move active window up (Vim),    movewindow, u"
          "$mainMod SHIFT, J, Move active window down (Vim),  movewindow, d"

          # Children keybindings
          # focus
          "$mainMod, left,  Move focus left (arrows),  movefocus, l"
          "$mainMod, right, Move focus right (arrows), movefocus, r"
          "$mainMod, up,    Move focus up (arrows),    movefocus, u"
          "$mainMod, down,  Move focus down (arrows),  movefocus, d"
          # move
          "$mainMod SHIFT, left,  Move active window left (arrows),  movewindow, l"
          "$mainMod SHIFT, right, Move active window right (arrows), movewindow, r"
          "$mainMod SHIFT, up,    Move active window up (arrows),    movewindow, u"
          "$mainMod SHIFT, down,  Move active window down (arrows),  movewindow, d"

          "$mainMod SHIFT, space, Toggle floating for active window, togglefloating"

          # Scratchpad
          "$mainMod, minus, Toggle scratchpad, togglespecialworkspace, scratchpad"
          "$mainMod SHIFT, minus, Move active window to scratchpad, movetoworkspacesilent, special:scratchpad"

          # lock
          "$mainMod, i, Lock screen, exec, ${
            if lockTargetsPresent then
              "loginctl lock-session"
            else
              "${lib.meta.getExe pkgs.hyprlock}"
          }"

          "$mainMod, R, Enter 'Resize' submap, submap, resize"

          # Media keys
          ", XF86AudioMute,  Toggle mute,     exec, ${volumeControl} tmute"
          ", XF86AudioPlay,  Toggle play/pause of currently playing media, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
          ", XF86AudioPause, Toggle play/pause of currently playing media, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
          ", XF86AudioPrev, Go to previous track, exec, ${pkgs.playerctl}/bin/playerctl previous"
          ", XF86AudioNext, Go to previous track, exec, ${pkgs.playerctl}/bin/playerctl next"

          # Power Menu
          "$mainMod SHIFT, E, Show Power Menu, exec, ${
            if config.programs.rofi.enable then
              "${config.programs.rofi.finalPackage}/bin/rofi -show p -modi p:'rofi-power-menu --logout ${logout}'"
            else
              "loginctl terminate-session"
          }"
        ] ++ (lib.lists.optionals (config.programs.rofi.enable
          && lib.lists.any (pkg: pkg == pkgs.rofi-calc)
          config.programs.rofi.plugins) [
            ''
              $mainMod, equal, Show quick calculator, exec, ${config.programs.rofi.finalPackage}/bin/rofi -modi calc -show calc -no-show-match -no-sort -calc-command "echo -n '{result}' | ${pkgs.wl-clipboard}/bin/wl-copy"
            ''
            ''
              , XF86Calculator, Show quick calculator (media key), exec, ${config.programs.rofi.finalPackage}/bin/rofi -modi calc -show calc -no-show-match -no-sort -calc-command "echo -n '{result}' | ${pkgs.wl-clipboard}/bin/wl-copy"
            ''
          ]) ++ (lib.lists.optional (config.programs.rofi.enable
            && lib.lists.any (pkg: pkg == pkgs.rofi-emoji-wayland)
            config.programs.rofi.plugins) ''
              $mainMod, semicolon, Show emoji picker, exec, ${config.programs.rofi.finalPackage}/bin/rofi -modi emoji -show emoji
            '') ++ (mkNumberBinds "$mainMod"
              (i: "Go to workspace ${i}, workspace, ${i}"))
          ++ (mkNumberBinds "$mainMod SHIFT" (i:
            "Move active window to workspace ${i}, movetoworkspacesilent, ${i}"))
          ++ (mkNumberBinds "$mainMod CTRL" (i:
            "Move active window and go to workspace ${i}, movetoworkspace, ${i}"));

        bindrd = [
          # Secreenshots
          "$mainMod SHIFT, S, Snip screen (partial screenshot), exec, ${snipTool}"
          "$mainMod, Print, Screenshot everything, exec, ${scTool}"
        ];

        bindedl = [
          # Media keys
          ", XF86AudioRaiseVolume, Incrase volume,  exec, ${volumeControl} increase 5"
          ", XF86AudioLowerVolume, Decrease volume, exec, ${volumeControl} decrease 5"

          # Brightness
          ", XF86MonBrightnessUp,   Increase screen brightness, exec, ${brightnessControl} increase 2"
          ", XF86MonBrightnessDown, Decrease screen brightness, exec, ${brightnessControl} decrease 2"
        ];

        misc = {
          font_family = "IosevkaTerm Nerd Font";
          vrr = 2;
        };

        ecosystem = {
          no_update_news = true;
          no_donation_nag = true;
        };

        layerrule = [ "animation slide right, notifications" ];

        windowrule = [
          "tag +coms, class:^(vesktop)$"
          "tag +coms, class:^(thunderbird)$"
          "tag +browser, class:^(librewolf)$"
          "tag +browser, class:^(firefox)$"
          "tag +browser, class:^(Chromium-browser)$"

          "float, class:org\\.pulseaudio\\.pavucontrol"
          "workspace 3 silent, tag:browser"
          "workspace 4 silent, tag:coms"
        ];
      };

      extraConfig = ''
        ${lib.strings.optionalString (cfg.submaps != { })
        (submapsToHyprConf cfg.submaps)}
      '';
    };

    specialisation = {
      light.configuration = {
        wayland.windowManager.hyprland.settings = {
          general = {
            "col.inactive_border" = "rgb(e1e2e7)";
            "col.active_border" = "rgb(3760bf)";
            "col.nogroup_border" = "rgb(e1e2e7)";
            "col.nogroup_border_active" = "rgb(3760bf)";
          };

          group = {
            "col.border_inactive" = "rgb(e1e2e7)";
            "col.border_active" = "rgb(3760bf)";
          };
        };
      };
      dark.configuration = {
        wayland.windowManager.hyprland.settings = {
          general = {
            "col.inactive_border" = "rgb(24283b)";
            "col.active_border" = "rgb(c0caf5)";
            "col.nogroup_border" = "rgb(24283b)";
            "col.nogroup_border_active" = "rgb(c0caf5)";
          };

          group = {
            "col.border_inactive" = "rgb(24283b)";
            "col.border_active" = "rgb(c0caf5)";
          };
        };
      };
    };

    tsrk.hyprland.submaps = {
      resize = {
        binded = [
          ", right, Grow width of active window,    resizeactive, 10 0"
          ", left,  Shrink width of active window,  resizeactive, -10 0"
          ", up,    Grow height of active window,   resizeactive, 0 10"
          ", down,  Shrink height of active window, resizeactive, 0 -10"

          # Vim-like keybindings
          ", L, Grow width of active window,    resizeactive, 10 0"
          ", H, Shrink width of active window,  resizeactive, -10 0"
          ", K, Grow height of active window,   resizeactive, 0 10"
          ", J, Shrink height of active window, resizeactive, 0 -10"
        ];

        bindd = [ ", catchall, Exit resize submap, submap, reset" ];
      };
    };
  };
}
