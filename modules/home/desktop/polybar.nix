{ config, lib, pkgs, osConfig ? { }, ... }:
let
  colors = {
    background = "#111";
    background-alt = "#222";
    foreground = "#dfdfdf";
    foreground-alt = "#555";
    primary = "#999";
    secondary = "#e60053";
    alert = "#bd2c40";
  };
  systemReady =
    if osConfig ? tsrk.i3.enable then
      osConfig.tsrk.i3.enable else true;
in
{
  services.polybar = lib.mkIf (systemReady && config.tsrk.i3.enable) {
    enable = lib.mkDefault true;
    script = "polybar bar &";

    package = pkgs.polybar.override {
      i3Support = true;
    };

    settings = {

      "bar/bar" = {
        inherit (colors) background foreground;

        line = {
          size = 3;
          color = "#f00";
        };

        border = {
          size = 0;
          color = "#00000000";
        };

        font = [
          "Iosevka Nerd Font:pixelsize=12;0"
          "MesloLG Nerd Font:pixelsize=12;0"
          "JetBrains Mono Nerd Font:pixelsize=12;0"
          "fixed:pixelsize=10;1"
          "unifont:fontformat=truetype:size=8:antialias=false;0"
          "siji:pixelsize=10;1"
        ];

        width = "100%";
        height = 40;
        radius = 0;
        fixed.center = false;

        modules = {
          margin = {
            left = 1;
            right = 1;
          };

          left = "i3";
          center = "xwindow";
          right = "date";
        };

        tray = {
          position = "right";
          padding = 0;
        };
      };

      "module/xwindow" = {
        type = "internal/xwindow";
        label = "%title:0:30:...%";
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
          focused-background = colors.background-alt;
          focused-underline = colors.primary;
          focused-padding = 2;

          unfocused = "%index%";
          unfocused-padding = 2;

          visible = "%index%";
          visible-background = focused-background;
          visible-underline = focused-underline;
          visible-padding = focused-padding;

          urgent = "%index%";
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
          prefix = "";
          prefix-forground = colors.foreground-alt;
        };

        label = "%date% %time%";
      };
    };
  };
}
