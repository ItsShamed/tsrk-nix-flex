{ config, lib, pkgs, self, ... }:

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
    services.polybar = {
      enable = lib.mkDefault true;
      script = "polybar bar &";

      package = pkgs.polybar.override {
        i3Support = config.xsession.windowManager.i3.enable;
        pulseSupport = true;
      };

      settings = {

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
          background = "\${colors.background}";
          background-alt = "\${colors.background-alt}";

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

          label.muted = {
            text = "muted";
            foreground = "\${colors.yellow}";
          };

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

          label = {
            mode = {
              padding = 2;
              foreground = "\${colors.background}";
              background = "\${colors.alert}";
            };

            focused = {
              text = "%index%";
              background = "\${colors.primary}";
              underline = "\${colors.foreground}";
              padding = 2;
            };

            unfocused = {
              text = "%index%";
              padding = 2;
            };

            visible = {
              text = "%index%";
              background = "\${colors.primary}";
              underline = "\${colors.foreground}";
              padding = 2;
            };

            urgent = {
              text = "%index%";
              foreground = "\${colors.background}";
              background = "\${colors.alert}";
              padding = 2;
            };
          };
        };

        "module/date" = {
          type = "internal/date";
          interval = 1;

          date = {
            text = "";
            alt = " %Y-%m-%d";
          };

          time = {
            text = "%l:%M:%S %p";
            alt = "%l:%M:%S %p";
          };

          format = {
            prefix = {
              text = " ";
              foreground = "\${colors.foreground-alt}";
            };
          };

          label = "%date%%time%";
        };

        "module/wifi" = {
          type = "internal/network";
          interface = {
            text = self.lib.mkIfElse (cfg.wlanInterfaceName != null) cfg.wlanInterfaceName "wlan0";
            type = "wireless";
          };

          format = {
            disconnected.prefix = "󰤮 ";
            connected.text = "<ramp-signal> <label-connected>";
          };

          label = {
            disconnected = {
              text = "down";
              foreground = "\${colors.red}";
            };
            connected = "%essid%";
          };

          ramp.signal = [
            "󰤯 "
            "󰤟 "
            "󰤢 "
            "󰤥 "
            "󰤨 "
          ];
        };

        "module/eth" = {
          type = "internal/network";
          interface = {
            text = self.lib.mkIfElse (cfg.ethInterfaceName != null) cfg.ethInterfaceName "eth0";
            type = "wireless";
          };

          format = {
            disconnected.prefix = "󰈂 ";
            connected = {
              text = "<label-connected>";
              prefix = "󰈁 ";
            };
          };

          label = {
            disconnected = {
              text = "down";
              foreground = "\${colors.red}";
            };
            connected = "%local_ip%";
          };
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
