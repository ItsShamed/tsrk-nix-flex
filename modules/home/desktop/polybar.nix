{ config, lib, pkgs, ... }:

let
  cfg = config.tsrk.polybar;
  polybarModules = modulesNames: lib.strings.concatStringsSep " " modulesNames;
in
{
  options = {
    tsrk.polybar = {
      enable = lib.options.mkEnableOption "polybar";
      wlanInterfaceName = lib.options.mkOption {
        type = lib.types.nullOr lib.types.str;
        description = "The name of the host wireless interface";
        default = null;
        example = "wlan0";
      };
      ethInterfaceName = lib.options.mkOption {
        type = lib.types.nullOr lib.types.str;
        description = "The name of the host wired interface";
        default = null;
        example = "eth0";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    services.polybar = lib.mkIf config.tsrk.i3.enable {
      enable = lib.mkDefault true;
      script = "polybar bar &";

      package = pkgs.polybar.override {
        i3Support = true;
        pulseSupport = true;
      };

      settings = rec {

        # Tokyo Night Storm colours
        colors = {
          background = "#1f2335";
          background-alt = "#24283b";
          foreground-alt = "#a9b1d6";
          foreground = "#c0caf5";
          primary = "#292e42";
          secondary = "#e60053";
          alert = "#f7768e";
          red = "#f7768e";
          yellow = "#e0af68";
        };

        "bar/bar" = {
          inherit (colors) background foreground;

          line = {
            size = 2;
            color = "#f00";
          };

          border = {
            size = 0;
            color = "#00000000";
          };

          font = [
            "Iosevka Nerd Font:pixelsize=10;0"
            "MesloLG Nerd Font:pixelsize=10;0"
            "JetBrains Mono Nerd Font:pixelsize=10;0"
            "fixed:pixelsize=10;1"
            "unifont:fontformat=truetype:size=8:antialias=false;0"
            "siji:pixelsize=10;1"
          ];

          padding.right = 1;

          width = "100%";
          height = 35;
          radius = 0;
          fixed.center = false;

          modules = {
            margin = {
              left = 1;
              right = 1;
            };

            left = polybarModules [ "i3" "xwindow" ];
            right = polybarModules (lib.lists.reverseList ([
              "tray"
              "date"
              "audio"
            ]
            ++ (lib.lists.optional (cfg.wlanInterfaceName != null) "wifi")
            ++ (lib.lists.optional (cfg.ethInterfaceName != null) "eth")));
          };

          separator = " | ";
        };

        "module/audio" = {
          type = "internal/pulseaudio";
          format = {
            volume = "<ramp-volume> <label-volume>";
            muted.prefix = "󰝟 ";
          };

          label-muted = "muted";
          label-muted-foreground = colors.yellow;

          ramp.volume = [
            "󰕿"
            "󰖀"
            "󰕾 "
          ];
        };

        "module/xwindow" = {
          type = "internal/xwindow";
          label = "%title:0:64:...%";
        };

        "module/i3" = {
          type = "internal/i3";
          format = "<label-state> <label-mode>";
          wrapping.scroll = false;

          label = rec {
            mode = {
              padding = 2;
              foreground = "#000";
              background = colors.primary;
            };

            focused = "%index%";
            focused-background = colors.primary;
            focused-underline = colors.foreground;
            focused-padding = 2;

            unfocused = "%index%";
            unfocused-padding = 2;

            visible = "%index%";
            visible-background = focused-background;
            visible-underline = focused-underline;
            visible-padding = focused-padding;

            urgent = "%index%";
            urgent-foreground = colors.background;
            urgent-background = colors.alert;
            urgent-padding = 2;
          };
        };

        "module/date" = rec {
          type = "internal/date";
          interval = 1;

          date = "";
          date-alt = " %Y-%m-%d";

          time = "%l:%M:%S %p";
          time-alt = time;

          format = {
            prefix = " ";
            prefix-forground = colors.foreground-alt;
          };

          label = "%date%%time%";
        };

        "module/wifi" = {
          type = "internal/network";
          interface = cfg.wlanInterfaceName;
          interface-type = "wireless";

          format-disconnected-prefix = "󰤮 ";
          label-disconnected = "down";
          label-disconnected-foreground = colors.red;

          label-connected = "%essid%";
          format-connected = "<ramp-signal> <label-connected>";

          ramp-signal = [
            "󰤯 "
            "󰤟 "
            "󰤢 "
            "󰤥 "
            "󰤨 "
          ];
        };

        "module/eth" = {
          type = "internal/network";
          interface = cfg.ethInterfaceName;
          interface-type = "wireless";

          format-disconnected-prefix = "󰈂 ";
          label-disconnected = "down";
          label-disconnected-foreground = colors.red;

          label-connected = "%local_ip%";
          format-connected = "<label-connected>";
          format-connected-prefix = "󰈁 ";
        };

        "module/tray" = {
          type = "internal/tray";
          tray = {
            spacing = 4;
            size = "50%";
          };
        };
      };
    };
  };
}
