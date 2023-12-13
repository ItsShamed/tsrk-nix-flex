{ config, pkgs, lib, osConfig ? {}, home-manager, ... }:

let
  mod = config.xsession.windowManager.i3.config.modifier;
  cfg = config.xsession.windowManager.i3.config;
  systemReady = if osConfig ? tsrk.i3.enable then
    osConfig.tsrk.i3.enable else true;
  lockCommand = if config.tsrk.i3.epitaRestrictions then
    "i3lock -i ${config.tsrk.i3.lockerBackground} -p win"
    else "${pkgs.betterlockscreen}/bin/betterlockscreen -l -- -p win";
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
    };
  };

  config = lib.mkIf (systemReady && config.tsrk.i3.enable) {
    xsession.windowManager.i3 = {
      enable = true;
      config = {
        modifier = "Mod4";
        terminal = "kitty";
        menu = "${pkgs.rofi}/bin/rofi -show drun";
        bars = [];

        startup = [
        {
          command = "feh --bg-scale ${config.tsrk.i3.background}";
          always = true;
        }
        ] ++ (lib.lists.optional (config.services.polybar.enable) {
            command = "systemctl --user restart polybar";
            always = true;
            });

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
        ];

        gaps = {
          outer = 15;
          inner = 15;
        };

        colors.focused = {
          border = "#edcb32";
          background = "#285577";
          text = "#ffffff";
          indicator = "#a0c20c";
          childBorder = "#edcb32";
        };

        colors.unfocused = {
          border = "#333333";
          background = "#222222";
          text = "#888888";
          indicator = "#edcb32";
          childBorder = "#222222";
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
          "${mod}+i" = "exec \"${lockCommand}\"";
          "${mod}+Shift+e" = "exec \" i3-nagbar -t warning -m 'Disconnect?' -b 'Yes' 'i3-msg exit'\"";

          "${mod}+Shift+r" = "restart";
          "${mod}+Shift+c" = "reload";
          "${mod}+r" = "mode \"resize\""; 
          "--release ${mod}+Shift+s" = "exec --no-startup-id \"${pkgs.flameshot}/bin/flameshot gui\"";
          "--release ${mod}+Print" = "exec --no-startup-id \"${pkgs.flameshot}/bin/flameshot full\"";
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

    systemd.user.services.setup-betterlockscreen = lib.mkIf (!config.tsrk.i3.epitaRestrictions) {
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };

      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.betterlockscreen}/bin/betterlockscreen -u ${config.tsrk.i3.lockerBackground}";
      };
    };
  };
}
