{ config, pkgs, lib, self, ... }:

let
  mod = config.xsession.windowManager.i3.config.modifier;
  cfg = config.xsession.windowManager.i3.config;
  lockCommand =
    if config.tsrk.i3.epitaRestrictions then
      "i3lock -i ${config.tsrk.i3.lockerBackground} -p win"
    else "${pkgs.betterlockscreen}/bin/betterlockscreen -l -- -p win";
  updateGtk = pkgs.writeShellScript "update-gtk" ''
    ${pkgs.lxappearance}/bin/lxappearance &
    ${pkgs.coreutils}/bin/sleep 1
    ${pkgs.killall}/bin/killall .lxappearance-wrapped
  '';

  teardown = pkgs.writeShellScript "i3-teardown" (lib.strings.concatLines [
    ''
      # This script is responsible for stopping all services started with i3
      # and to stop i3
    ''
    (lib.strings.optionalString config.services.polybar.enable ''
      # Polybar
      systemctl --user disable --now polybar
    '')
    (lib.strings.optionalString config.services.xsettingsd.enable ''
      # xsettingsd
      systemctl --user disable --now xsettingsd
    '')
    (lib.strings.optionalString config.services.darkman.enable ''
      # darkman
      systemctl --user disable --now darkman
    '')
    (lib.strings.optionalString config.tsrk.i3.useLogind ''
      # i3lock service
      # This service runs when the lock.target is reach and before sleeping
      systemctl --user disable --now i3lock
    '')
    ''
      # Stop i3
      i3-msg exit
    ''
  ]);

  i3Config = lib.mkIf config.tsrk.i3.enable {
    xsession.windowManager.i3 = {
      enable = true;
      config = {
        modifier = "Mod4";
        terminal = (self.lib.mkIfElse (config.programs.kitty.enable)
          (self.lib.mkGL config "kitty")
          # This is for the EPITA die-hards that never bothered to change their
          # default terminal emulator for their session lol
          (self.lib.mkGL config "${pkgs.alacritty}/bin/alacritty")
        );
        menu = (self.lib.mkIfElse (config.programs.rofi.enable)
          "sh -c \"rofi -show drun\""
          "${pkgs.dmenu}/bin/dmenu_run"
        );
        bars = [ ];

        startup = (lib.lists.optional (!config.services.darkman.enable) {
          command = "feh --bg-scale ${config.tsrk.i4.background}";
          always = false;
        }) ++ (lib.lists.optional (config.services.polybar.enable) {
          command = "systemctl --user enable --now polybar";
          always = true;
        }) ++ (lib.lists.optional (config.services.xsettingsd.enable) {
          command = "systemctl --user enable --now xsettingsd";
          always = false;
        }) ++ (lib.lists.optional (config.tsrk.i3.useLogind) {
          command = "systemctl --user enable i3lock";
          always = false;
        }) ++ (lib.lists.optionals (config.services.darkman.enable) [
          {
            command = "systemctl --user enable --now darkman";
            always = false;
          }
          {
            command = "sh ${updateGtk}";
            always = true;
          }
        ]);

        window.titlebar = false;
        window.commands = [
          # Enable border for "normal" windows
          {
            command = "border pixel 3";
            criteria = {
              class = "^.*";
            };
          }

          # Floating only for Pavucontrol
          {
            command = "floating enable";
            criteria = {
              class = "Pavucontrol";
            };
          }

          # Floating only for lxappearance
          {
            command = "floating enable";
            criteria = {
              class = ".xappearance";
            };
          }

          {
            command = "floating enable";
            criteria = {
              window_role = "alert";
            };
          }
        ];

        gaps = {
          outer = 10;
          inner = 10;
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

          # lock
          "${mod}+i" = (self.lib.mkIfElse config.tsrk.i3.useLogind "exec loginctl lock-session" "exec \"${lockCommand}\"");
          "${mod}+Shift+e" = lib.mkDefault "exec \" i3-nagbar -t warning -m 'Disconnect?' -b 'Yes' 'sh ${teardown}'\"";

          "${mod}+Shift+r" = "restart";
          "${mod}+Shift+c" = "reload";
          "${mod}+r" = "mode \"resize\"";
          "--release ${mod}+Shift+s" = (self.lib.mkIfElse config.services.flameshot.enable
            "exec --no-startup-id \"flameshot gui\""
            "exec --no-startup-id \"${pkgs.scrot}/bin/scrot '/tmp/scrot-$a$Y%m%d%h%m%s.png' -s -e '${pkgs.xclip}/bin/xclip -selection clipboard -t image/png -i $f; rm $f'\""
          );
          "--release ${mod}+Print" = (self.lib.mkIfElse config.services.flameshot.enable
            "exec --no-startup-id \"flameshot full\""
            "exec --no-startup-id \"${pkgs.scrot}/bin/scrot '/tmp/scrot-$a$Y%m%d%h%m%s.png' -e '${pkgs.xclip}/bin/xclip -selection clipboard -t image/png -i $f; rm $f'\""
          );
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
          WantedBy = [ "graphical-session.target" ];
        };

        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.betterlockscreen}/bin/betterlockscreen -u ${config.tsrk.i3.lockerBackground}";
        };
      };
    };
  };

  logindConfig = lib.mkIf config.tsrk.i3.useLogind {

    home.packages = with pkgs; [
      pkgs.systemd-lock-handler
    ];

    systemd.user.targets = {
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
          Description = "User-level target triggered when the system is about to sleep.";
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

        Install = {
          WantedBy = [ "default.target" ];
        };
      };

      i3lock = {
        Unit = {
          Description = "Locks the current user session";
          PartOf = "lock.target";
          After = "lock.target";
          Before = "sleep.target";
        };

        Service = {
          ExecStart = lockCommand;
          Type = "forking";
          Restart = "on-failure";
          RestartSec = "0s";
        };

        Install = {
          WantedBy = [ "lock.target" "sleep.target" ];
        };
      };
    };
  };
in
{
  options = {
    tsrk.i3 = {
      enable = lib.options.mkEnableOption "tsrk's i3 configuration";
      lockerBackground = lib.options.mkOption {
        description = "Path to the background image for the locker.";
        type = lib.types.path;
        default = ./files/torekka.png;
      };
      background = lib.options.mkOption {
        description = "Path to the main wallpaper background.";
        type = lib.types.path;
        default = ./files/bg-no-logo.png;
      };
      epitaRestrictions = lib.options.mkEnableOption "compliance with EPITA
        regulations by using stock i3lock as the locker";
      useLogind = lib.options.mkEnableOption "locking using logind";
    };
  };

  config = lib.mkMerge [
    i3Config
    logindConfig
  ];
}
