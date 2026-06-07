# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, ... }:

{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib.generators) mkLuaInline;
  toLua = lib.generators.toLua { };
  cfg = config.tsrk.hyprland;
  hyprlandCfg = config.wayland.windowManager.hyprland;
  mkNumberBinds =
    mod: keywordFn:
    (builtins.foldl' (c: e: c ++ [ "${mod}, ${e}, ${keywordFn e}" ]) [ ] (
      builtins.genList (x: toString (x + 1)) 9
    ))
    ++ [ "${mod}, 0, ${keywordFn "10"}" ];
  lockTargetsPresent =
    let
      targets = config.systemd.user.targets;
    in
    targets ? lock && targets ? sleep && targets ? unlock;

  volumeControl = pkgs.writeShellScript "volume-control" ''
    notifyVolume_() {
      # Cancel launching notification if syshud is launched
      if pgrep syshud; then
        return 0
      fi

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
      # Cancel launching notification if syshud is launched
      if pgrep syshud; then
        return 0
      fi

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

  snipTool =
    with lib.meta;
    pkgs.writeShellScript "snip-tool" ''${getExe pkgs.grim} -g "$(${getExe pkgs.slurp} -o -r -c '#ff0000ff')" -t ppm - | ${getExe pkgs.satty} --filename - --fullscreen --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png --copy-command ${pkgs.wl-clipboard}/bin/wl-copy'';

  scTool = "${lib.meta.getExe pkgs.grim} $(date '+%Y%m%d-%H:%M:%S').png";

  logout = pkgs.writeShellScript "terminate-session-wrapper" ''
    if command -v uwsm >/dev/null; then
      systemctl --user stop hyprland-session.target
      uwsm stop
    else
      loginctl terminate-session "$XDG_SESSION_ID"
    fi
  '';

  launch = pkgs.writeShellScript "launch-app" ''
    if command -v uwsm >/dev/null; then
      exec uwsm app -- "$@"
    else
      exec "$@"
    fi
  '';

  menu = pkgs.writeShellScript "menu-wrapper" ''
    echo "Supplied menu:" "$@"

    menu="$(basename "$1")"

    if [ "$#" -lt 1 ]; then
      exit 1;
    fi

    if [ "$menu" = "rofi" ]; then
      if command -v uwsm >/dev/null; then
        exec "$@" -run-command 'uwsm app -- {cmd}'
      else
        exec "$@"
      fi
      exit
    fi

    if [ "$menu" = "bemenu-run" ]; then
      if command -v uwsm >/dev/null; then
        exec uwsm app -- "$("$@" --no-exec)"
      else
        exec "$@"
      fi
    fi

    if [ "$menu" = "fuzzel" ]; then
      if command -v uwsm >/dev/null; then
        exec "$@" --launch-prefix='uwsm app -- '
      else
        exec "$@"
      fi
    fi

    if [ "$menu" = "tofi-drun" ] && [ "$#" -eq 1 ]; then
      if command -v uwsm >/dev/null; then
        exec uwsm app -- "$("$@")"
      else
        exec "$@"
      fi
    fi
  '';
in
{
  key = ./hyprland.nix;

  imports = with self.homeManagerModules; [
    session-targets
    (lib.modules.mkRemovedOptionModule [
      "tsrk"
      "hyprland"
      "submaps"
    ] "Use Home-Manager's wayland.windowManager.hyprland.submaps instead")
  ];

  options = {
    tsrk.hyprland = {
      enable = lib.options.mkEnableOption "tsrk's Hyprland configuration";
      uwsm = {
        extraEnv = lib.options.mkOption {
          description = "Extra options to pass to UWSM";
          type = lib.types.lines;
          default = "";
        };
      };
      backgrounds = {
        lockscreen = lib.options.mkOption {
          description = "Image to use as the lockscreen background";
          type = lib.types.path;
          default = ./files/tehfire.png;
        };
        default = lib.options.mkOption {
          description = "Image to use as the default backgroud (when Darkman is disabled)";
          type = lib.types.path;
          default = ./files/bg-no-logo.png;
        };
        light = lib.options.mkOption {
          description = "Image to use as a light-theme background (needs Darkman)";
          type = lib.types.path;
          default = ./files/torekka.png;
        };
        dark = lib.options.mkOption {
          description = "Image to use as a dark-themed background (needs Darkman)";
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
    tsrk.sessionTargets.enable = lib.mkDefault true;
    wayland.systemd.target = lib.mkDefault "hyprland-session.target";

    programs.hyprlock = {
      enable = lib.mkDefault true;
      settings = {
        general = {
          ignore_empty_input = true;
        };

        background.path = "${cfg.backgrounds.lockscreen}";

        debug.disable_logs = lib.mkDefault false;

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
        splash = false;
        wallpaper = {
          monitor = "";
          path = "${cfg.backgrounds.default}";
        };
      };
    };

    services.darkman = lib.mkIf cfg.darkman.enable {
      lightModeScripts.hyprpaper = ''
        if [ "''${XDG_SESSION_TYPE:-}" = "wayland" ] && [ -n "''${WAYLAND_DISPLAY:-}" ]; then
          tries=0
          while (! hyprctl hyprpaper wallpaper ", ${cfg.backgrounds.light}") && [ "$tries" -lt 5 ]; do
            echo "Failed to set wallpaper, retrying…"
            sleep 1
            tries=$(($tries + 1))
          done
        else
          echo "Not running Wayland, skipping hyprpaper" >&2
        fi
      '';
      darkModeScripts.hyprpaper = ''
        if [ "''${XDG_SESSION_TYPE:-}" = "wayland" ] && [ -n "''${WAYLAND_DISPLAY:-}" ]; then
          tries=0
          while (! hyprctl hyprpaper reload ", ${cfg.backgrounds.dark}") && [ "$tries" -lt 5 ]; do
            echo "Failed to set wallpaper, retrying…"
            sleep 1
            tries=$(($tries + 1))
          done
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
            on-timeout = "${pkgs.libnotify}/bin/notify-send -a hypridle 'Auto-lock notice' 'Computer will lock in 10 seconds'";
            on-resume = "${pkgs.libnotify}/bin/notify-send -a hypridle 'Auto-lock notice' 'Cancelled'";
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

    xdg.configFile."uwsm/env-Hyprland" = {
      text = ''
        # Base environment variables
        if [ "$XDG_SESSION_DESKTOP" != "Hyprland" ]; then
          export XDG_SESSION_DESKTOP=Hyprland
        fi

        if [ "$XDG_CURRENT_DESKTOP" != "Hyprland" ]; then
          export XDG_CURRENT_DESKTOP=Hyprland
        fi

        # Extra environment variables
        ${cfg.uwsm.extraEnv}
      '';
    };

    wayland.windowManager.hyprland = {
      enable = lib.mkDefault true;
      systemd.enable = lib.mkDefault true;
      configType = lib.mkDefault "lua";
      settings = {
        config = {
          general = {
            border_size = 2;
            gaps_in = 5;
            gaps_out = 10;
            gaps_workspaces = 10;
            resize_on_border = true;
          };

          decoration = {
            rounding = 10;
            inactive_opacity = 0.75;
            shadow = {
              render_power = 2;
              color_inactive = "rgba(00000000)";
            };
          };
          dwindle.force_split = 2;

          input = {
            repeat_rate = 45;
            repeat_delay = 244;
            touchpad.natural_scroll = true;
          };
          binds.drag_threshold = 5;

          misc = {
            font_family = "IosevkaTerm Nerd Font";
            vrr = 2;
          };

          ecosystem = {
            no_update_news = true;
            no_donation_nag = true;
          };
        };

        "mainMod"._var = "SUPER";
        "terminal"._var = (
          self.lib.mkIfElse (config.programs.kitty.enable) "kitty"
            # This is for the EPITA die-hards that never bothered to change their
            # default terminal emulator for their session lol
            "${config.lib.nixGL.wrap pkgs.alacritty}/bin/alacritty"
        );
        "menu"._var = (
          self.lib.mkIfElse (config.programs.rofi.enable
          ) "rofi -show drun" "${pkgs.bemenu}/bin/bemenu-run"
        );

        # Needed to propagate necessary envvars to darkman
        execr-once = lib.mkIf (hyprlandCfg.configType == "hyprlang") (
          lib.lists.optional cfg.darkman.enable "systemctl --user restart darkman"
        );

        on._args =
          let
            exec = lib.lists.optional cfg.darkman.enable "systemctl --user restart darkman";
          in
          lib.optionals (hyprlandCfg.configType == "lua") [
            "hyprland.start"
            (mkLuaInline ''
              function ()
                -- Exec
                ${lib.concatMapStringsSep "  \n" (e: ''hl.exec_cmd("${e}")'') exec}
              end
            '')
          ];

        bind =
          let
            directionsTypes = {
              Vim = {
                left = "H";
                right = "L";
                up = "K";
                down = "J";
              };
              arrows = {
                left = "left";
                right = "right";
                up = "up";
                down = "down";
              };
            };
            mkMainModKey = key: mkLuaInline ''mainMod .. " + ${key}"'';
            mkLuaNumberBinds =
              keyFn: argsFn:
              (builtins.foldl' (
                c: e:
                c
                ++ [
                  {
                    _args = [
                      (mkMainModKey (keyFn e))
                    ]
                    ++ (argsFn e);
                  }
                ]
              ) [ ] (builtins.genList (x: toString (x + 1)) 9))
              ++ [
                {
                  _args = [
                    (mkMainModKey (keyFn "0"))
                  ]
                  ++ (argsFn "0");
                }
              ];
            mkExec' = key: action: description: opts: {
              _args = [
                key
                (mkLuaInline "hl.dsp.exec_cmd(${toLua action})")
                (opts // { inherit description; })
              ];
            };
            mkExec =
              k: a: d:
              mkExec' k a d { };
            mkLocalDirectionBinds =
              name: localDirections:
              let
                mkSingleDirection = direction: [
                  {
                    _args = [
                      (mkMainModKey "${localDirections.${direction}}")
                      (mkLuaInline "hl.dsp.focus(${toLua { inherit direction; }})")
                      { description = "Move focus ${direction} (${name})"; }
                    ];
                  }
                  {
                    _args = [
                      (mkMainModKey "SHIFT + ${localDirections.${direction}}")
                      (mkLuaInline "hl.dsp.window.move(${toLua { inherit direction; }})")
                      { description = "Move active window ${direction} (${name})"; }
                    ];
                  }
                ];
              in
              map mkSingleDirection (builtins.attrNames localDirections);
          in
          lib.optionals (hyprlandCfg.configType == "lua") (
            [
              {
                _args = [
                  (mkMainModKey "mouse:272")
                  (mkLuaInline "hl.dsp.window.drag()")
                  {
                    mouse = true;
                    description = "Move active window by dragging";
                  }
                ];
              }
              {
                _args = [
                  (mkMainModKey "mouse:273")
                  (mkLuaInline "hl.dsp.window.resize()")
                  {
                    mouse = true;
                    description = "Resize active window by dragging";
                  }
                ];
              }
              {
                _args = [
                  (mkMainModKey "Return")
                  (mkLuaInline ''hl.dsp.exec_cmd("${launch} " .. terminal)'')
                  { description = "Open terminal emulator"; }
                ];
              }
              {
                _args = [
                  (mkMainModKey "SHIFT + Q")
                  (mkLuaInline "hl.dsp.window.close()")
                  { description = "Close active window"; }
                ];
              }
              {
                _args = [
                  (mkMainModKey "D")
                  (mkLuaInline ''hl.dsp.exec_cmd("${menu} " .. menu)'')
                  { description = "Open Menu"; }
                ];
              }
              {
                _args = [
                  (mkMainModKey "F")
                  (mkLuaInline "hl.dsp.window.fullscreen(${
                    toLua {
                      mode = "fullscreen";
                      action = "toggle";
                    }
                  })")
                  { description = "Toggle fullscreen on active window"; }
                ];
              }
              {
                _args = [
                  (mkMainModKey "SHIFT + F")
                  (mkLuaInline "hl.dsp.window.fullscreen(${
                    toLua {
                      mode = "maximized";
                      action = "toggle";
                    }
                  })")
                  { description = "Toggle maximizing on active window"; }
                ];
              }
              {
                _args = [
                  (mkMainModKey "SPACE")
                  (mkLuaInline ''hl.dsp.window.float({ action = "toggle" })'')
                  { description = "Toggle floating for active window"; }
                ];
              }
              {
                _args = [
                  (mkMainModKey "MINUS")
                  (mkLuaInline ''hl.dsp.workspace.toggle_special("scratchpad")'')
                  { description = "Toggle scratchpad"; }
                ];
              }
              {
                _args = [
                  (mkMainModKey "SHIFT + MINUS")
                  (mkLuaInline "hl.dsp.window.move(${
                    toLua {
                      workspace = "special:scratchpad";
                      follow = false;
                    }
                  })")
                  { description = "Toggle scratchpad"; }
                ];
              }
              (mkExec (mkMainModKey "I") "${
                if lockTargetsPresent then
                  "loginctl lock-session"
                else
                  "${lib.meta.getExe pkgs.hyprlock}"
              }" "Lock screen")
              {
                _args = [
                  (mkMainModKey "R")
                  (mkLuaInline ''hl.dsp.submap("resize")'')
                  { description = "Enter 'Resize' submap"; }
                ];
              }
              (mkExec "XF86AudioMute" "${volumeControl} tmute" "Toggle Mute")
              (mkExec "XF86AudioPlay" "${lib.getExe pkgs.playerctl} play-pause"
                "Toggle play/pause of currently playing media"
              )
              (mkExec "XF86AudioPause" "${lib.getExe pkgs.playerctl} play-pause"
                "Toggle play/pause of currently playing media"
              )
              (mkExec "XF86AudioPrev" "${lib.getExe pkgs.playerctl} previous"
                "Go to previous track"
              )
              (mkExec "XF86AudioNext" "${lib.getExe pkgs.playerctl} next" "Go to next track")
              (mkExec (mkMainModKey "SHIFT + E") "${
                if config.programs.rofi.enable then
                  "${config.programs.rofi.finalPackage}/bin/rofi -show p -modi p:'rofi-power-menu --logout ${logout}'"
                else
                  "${logout}"
              }" "Show Power Menu")
              (mkExec' (mkMainModKey "SHIFT + S") "${launch} ${snipTool}"
                "Snip screen (partial screenshot)"
                {
                  release = true;
                }
              )
              (mkExec' (mkMainModKey "Print") "${launch} ${scTool}" "Screenshot everything" {
                release = true;
              })
              (mkExec' "XF86AudioRaiseVolume" "${launch} ${volumeControl} increase 5"
                "Increase volume"
                {
                  repeating = true;
                  locked = true;
                }
              )
              (mkExec' "XF86AudioLowerVolume" "${launch} ${volumeControl} decrease 5"
                "Decrease volume"
                {
                  repeating = true;
                  locked = true;
                }
              )
              (mkExec' "XF86MonBrightnessUp" "${launch} ${brightnessControl} increase 2"
                "Increase screen brightness"
                {
                  repeating = true;
                  locked = true;
                }
              )
              (mkExec' "XF86MonBrightnessDown" "${launch} ${brightnessControl} decrease 2"
                "Decrease screen brightness"
                {
                  repeating = true;
                  locked = true;
                }
              )
            ]
            ++ (mkLuaNumberBinds lib.id (i: [
              (mkLuaInline "hl.dsp.focus(${
                toLua {
                  workspace = i;
                }
              })")
              { description = "Go to workspace ${i}"; }
            ]))
            ++ (mkLuaNumberBinds (i: "SHIFT + ${i}") (i: [
              (mkLuaInline "hl.dsp.window.move(${
                toLua {
                  workspace = i;
                  focus = false;
                }
              })")
              { description = "Move active window to workspace ${i}"; }
            ]))
            ++ (mkLuaNumberBinds (i: "CTRL + ${i}") (i: [
              (mkLuaInline "hl.dsp.window.move(${
                toLua {
                  workspace = i;
                  focus = true;
                }
              })")
              { description = "Move active window and go to workspace ${i}"; }
            ]))
            ++ (lib.flatten (lib.mapAttrsToList mkLocalDirectionBinds directionsTypes))
            ++ (lib.lists.optionals
              (
                config.programs.rofi.enable
                && lib.lists.any (pkg: pkg == pkgs.rofi-calc) config.programs.rofi.plugins
              )
              [
                (mkExec (mkMainModKey "equal")
                  ''${config.programs.rofi.finalPackage}/bin/rofi -modi calc -show calc -no-show-match -no-sort -calc-command "echo -n '{result}' | ${pkgs.wl-clipboard}/bin/wl-copy''
                  "Show quick calculator"
                )
                (mkExec "XF86Calculator"
                  ''${config.programs.rofi.finalPackage}/bin/rofi -modi calc -show calc -no-show-match -no-sort -calc-command "echo -n '{result}' | ${pkgs.wl-clipboard}/bin/wl-copy''
                  "Show quick calculator (media key)"
                )
              ]
            )
            ++ (lib.lists.optional
              (
                config.programs.rofi.enable
                && lib.lists.any (pkg: pkg == pkgs.rofi-emoji) config.programs.rofi.plugins
              )
              (
                mkExec (mkMainModKey "semicolon")
                  "${config.programs.rofi.finalPackage}/bin/rofi -modi emoji -show emoji"
                  "Show emoji picker"
              )
            )

          );

        bindmd = lib.optionals (hyprlandCfg.configType == "hyprlang") [
          "$mainMod, mouse:272, Move active window by dragging, movewindow"
          "$mainMod, mouse:273, Resize active window by dragging, resizewindow"
        ];

        bindd = lib.optionals (hyprlandCfg.configType == "hyprlang") (
          [
            "$mainMod, Return, Open terminal emulator, exec, ${launch} $terminal"
            "$mainMod SHIFT, Q, Kill active window, killactive"
            "$mainMod, D, Open Menu, exec, ${menu} $menu"

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
                "${logout}"
            }"
          ]
          ++ (lib.lists.optionals
            (
              config.programs.rofi.enable
              && lib.lists.any (pkg: pkg == pkgs.rofi-calc) config.programs.rofi.plugins
            )
            [
              ''
                $mainMod, equal, Show quick calculator, exec, ${config.programs.rofi.finalPackage}/bin/rofi -modi calc -show calc -no-show-match -no-sort -calc-command "echo -n '{result}' | ${pkgs.wl-clipboard}/bin/wl-copy"
              ''
              ''
                , XF86Calculator, Show quick calculator (media key), exec, ${config.programs.rofi.finalPackage}/bin/rofi -modi calc -show calc -no-show-match -no-sort -calc-command "echo -n '{result}' | ${pkgs.wl-clipboard}/bin/wl-copy"
              ''
            ]
          )
          ++ (lib.lists.optional
            (
              config.programs.rofi.enable
              && lib.lists.any (pkg: pkg == pkgs.rofi-emoji) config.programs.rofi.plugins
            )
            ''
              $mainMod, semicolon, Show emoji picker, exec, ${config.programs.rofi.finalPackage}/bin/rofi -modi emoji -show emoji
            ''
          )
          ++ (mkNumberBinds "$mainMod" (i: "Go to workspace ${i}, workspace, ${i}"))
          ++ (mkNumberBinds "$mainMod SHIFT" (
            i: "Move active window to workspace ${i}, movetoworkspacesilent, ${i}"
          ))
          ++ (mkNumberBinds "$mainMod CTRL" (
            i: "Move active window and go to workspace ${i}, movetoworkspace, ${i}"
          ))
        );

        bindrd = lib.optionals (hyprlandCfg.configType == "hyprlang") [
          # Screenshots
          "$mainMod SHIFT, S, Snip screen (partial screenshot), exec, ${launch} ${snipTool}"
          "$mainMod, Print, Screenshot everything, exec, ${launch} ${scTool}"
        ];

        bindedl = lib.optionals (hyprlandCfg.configType == "hyprlang") [
          # Media keys
          ", XF86AudioRaiseVolume, Incrase volume,  exec, ${launch} ${volumeControl} increase 5"
          ", XF86AudioLowerVolume, Decrease volume, exec, ${launch} ${volumeControl} decrease 5"

          # Brightness
          ", XF86MonBrightnessUp,   Increase screen brightness, exec, ${launch} ${brightnessControl} increase 2"
          ", XF86MonBrightnessDown, Decrease screen brightness, exec, ${launch} ${brightnessControl} decrease 2"
        ];

        animation =
          let
            syntaxes = {
              hyprlang = [ "global, 1, 3, default" ];
              lua = [
                {
                  leaf = "global";
                  enabled = true;
                  speed = 3.0;
                  bezier = "default";
                }
              ];
            };
          in
          syntaxes.${hyprlandCfg.configType};

        layer_rule = lib.optionals (hyprlandCfg.configType == "lua") [
          {
            match.namespace = "notifications";
            animation = "slide right";
          }
          {
            match.namespace = "waybar";
            animation = "slide up";
          }
          {
            match.namespace = "eww-bottom-dock";
            animation = "slide down";
          }
        ];

        workspace = lib.optionals (hyprlandCfg.configType == "hyprlang") [
          "1, defaultName:workdir"
          "2, defaultName:tooling"
          "3, defaultName:web"
          "4, defaultName:coms"
        ];

        workspace_rule =
          let
            mkWorkspaceRule =
              workspace: rules:
              {
                workspace = toString workspace;
              }
              // rules;
          in
          lib.optionals (hyprlandCfg.configType == "lua") [
            (mkWorkspaceRule 1 { default_name = "workdir"; })
            (mkWorkspaceRule 2 { default_name = "tooling"; })
            (mkWorkspaceRule 3 { default_name = "web"; })
            (mkWorkspaceRule 4 { default_name = "coms"; })
          ];

        gesture =
          let
            syntaxes = {
              hyprlang = [
                "4, horizontal, workspace"
              ];
              lua = [
                {
                  fingers = 4;
                  direction = "horizontal";
                  action = "workspace";
                }
              ];
            };
          in
          syntaxes.${hyprlandCfg.configType};

        windowrule = lib.optionals (hyprlandCfg.configType == "hyprlang") [
          "tag +coms, class:^(vesktop)$"
          "tag +coms, class:^(thunderbird)$"
          "tag +browser, class:^(librewolf)$"
          "tag +browser, class:^(firefox)$"
          "tag +browser, class:^(Chromium-browser)$"
          "tag +pip, initialTitle:^(Picture-in-Picture)$"
          "tag +pip, initialTitle:^(Picture in pIcture)$"

          "float, class:org\\.pulseaudio\\.pavucontrol"
          "float, class:com\\.saivert\\.pwvucontrol"
          "float, class:com\\.gabm\\.satty"
          "float, class:steam, title:^(Friends List)$"
          "float, tag:pip"
          "float, tag:browser, title:^Extension:.*"
          "pin, tag:pip"
          "workspace 3 silent, tag:browser"
          "workspace 4 silent, tag:coms"
        ];

        window_rule =
          let
            rulesAttrs = {
              vesktop-to-coms = {
                match.class = "^(vesktop)$";
                tag = "+coms";
              };
              thunderbird-to-coms = {
                match.class = "^(thunderbird)$";
                tag = "+coms";
              };
              firefox-as-browser = {
                match.class = "^(firefox)$";
                tag = "+browser";
              };
              librewolf-as-browser = {
                match.class = "^(librewolf)$";
                tag = "+browser";
              };
              chromium-as-browser = {
                match.class = "^(Chromium-browser)$";
                tag = "+browser";
              };
              match-pip = {
                match.initial_title = "^Picture(-| )in(-| )Picture$";
                tag = "+pip";
              };
              pavucontrol-float = {
                match.class = "org\\.pulseaudio\\.pavucontrol";
                float = true;
              };
              pwvucontrol-float = {
                match.class = "com\\.saivert\\.pwvucontrol";
                float = true;
              };
              steam-non-main-float = {
                match = {
                  class = "steam";
                  initial_title = "negative:^(Steam)$";
                };
                float = true;
              };
              pip-effect = {
                match.tag = "pip";
                float = true;
                pin = true;
              };
              browser-effect = {
                match.tag = "browser";
                workspace = "3 silent";
              };
              coms-effect = {
                match.tag = "coms";
                workspace = "3 silent";
              };
              satty = {
                match.class = "com\\.gabm\\.satty";
                float = true;
                fullscreen = true;
                no_anim = true;
                no_dim = true;
                no_blur = true;
                opaque = true;
              };
            };
          in
          lib.optionals (hyprlandCfg.configType == "lua") (
            lib.mapAttrsToList (name: value: value // { inherit name; }) rulesAttrs
          );
      };

      submaps = {
        resize.settings = {
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
            ", catchall, Exit resize submap, submap, reset"
          ];
          bind =
            let
              mkResizeBind = keybind: x: y: description: {
                _args = [
                  keybind
                  (mkLuaInline "hl.dsp.window.resize(${
                    toLua {
                      inherit x y;
                      relative = true;
                    }
                  })")
                  {
                    repeating = true;
                    inherit description;
                  }
                ];
              };
            in
            [
              (mkResizeBind "right" 10 0 "Grow width of active window")
              (mkResizeBind "left" (-10) 0 "Shrink width of active window")
              (mkResizeBind "up" 0 10 "Grow height of active window")
              (mkResizeBind "down" 0 (-10) "Shrink height of active window")

              # Vim-like keybindings
              (mkResizeBind "L" 10 0 "Grow width of active window")
              (mkResizeBind "H" (-10) 0 "Shrink width of active window")
              (mkResizeBind "K" 0 10 "Grow height of active window")
              (mkResizeBind "J" 0 (-10) "Shrink height of active window")
              {
                _args = [
                  "catchall"
                  (mkLuaInline ''hl.dsp.submap("reset")'')
                ];
              }
            ];
        };
      };
    };

    specialisation = {
      light.configuration = {
        wayland.windowManager.hyprland.settings.config = {
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
        wayland.windowManager.hyprland.settings.config = {
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
  };
}
