{ config, lib, pkgs, ... }:

{
  options = {
    tsrk.dunst.enable = lib.options.mkEnableOption "tsrk's dunst config";
  };

  config = lib.mkIf config.tsrk.dunst.enable {
    services.dunst = {
      enable = lib.mkDefault true;
      settings = {
        global = {
          follow = "mouse";

          width = "(50, 500)";
          height = 500;

          origin = "top-right";
          offset = "10x50";

          scale = 0;

          notification_limit = 0;

          progress_bar = true;
          progress_bar_height = 10;
          progress_bar_frame_width = 1;
          progress_bar_min_width = 150;
          progress_bar_max_width = 150;

          indicate_hidden = true;

          transparency = 0;

          separator_height = 0;

          padding = 15;
          horizontal_padding = 15;

          text_icon_padding = 0;

          frame_width = 3;
          frame_color = "#aaaaaa";
          separate_color = "frame";
          sort = true;

          font = "Iosevka Nerd Font 10";
          line_height = 0;

          markup = "full";
          format = "<b><u><span font_size=\"12.5pt\">%a</span></u> - %s</b>\\n<span font_size=\"10.5pt\">%b %p</span>";

          alignment = "left";
          vertical_alignment = "center";

          show_age_threshold = 5;

          ellipsize = "middlle";

          stack_duplicates = true;
          hide_duplicate_count = false;

          show_indicators = true;

          icon_position = "left";
          min_icon_size = 16;
          max_icon_size = 64;

          title = "Dunst";
          class = "Dunst";

          corner_radius = 10;

          mouse_left_click = "close_current";
          mouse_middle_click = "do_action, close_current";
          mouse_right_click = "close_all";
        };
        urgency_low = {
          frame_color = lib.mkDefault "#1D918B";
          background = lib.mkDefault "#18191E";
          foreground = lib.mkDefault "#FFEE79";
          timeout = 3;
        };
        urgency_normal = {
          frame_color = lib.mkDefault "#D16BB7";
          background = lib.mkDefault "#18191E";
          foreground = lib.mkDefault "#FFEE79";
          timeout = 5;
        };
        urgency_critical = {
          frame_color = lib.mkDefault "#FC2929";
          background = lib.mkDefault "#18191E";
          foreground = lib.mkDefault "#FFFF00";
          timeout = 0;
        };
        spotify = {
          appname = "Spotify";
          frame_color = "#1DB954";
          alignment = "left";
          ellipsize = "end";
          min_icon_size = 128;
          max_icon_size = 128;
          horizontal_padding = 0;
          icon_position = "left";
          timeout = 5;
        };
        scrot = {
          summary = "scrot";
          format = "<b>  %s</b>\\n%b";
        };
      };
    };

    specialisation = {
      light.configuration = {
        services.dunst.settings = {
          urgency_low = {
            frame_color = lib.mkForce "#3760bf";
            background = lib.mkForce "#e9e9ec";
            foreground = lib.mkForce "#3760bf";
          };
          urgency_normal = {
            frame_color = lib.mkForce "#3760bf";
            background = lib.mkForce "#e1e2e7";
            foreground = lib.mkForce "#3760bf";
          };
          urgency_critical = {
            frame_color = lib.mkForce "#c64343";
            background = lib.mkForce "#c4c8da";
            foreground = lib.mkForce "#c64343";
          };
        };
      };

      dark.configuration = {
        services.dunst.settings = {
          urgency_low = {
            frame_color = lib.mkForce "#c0caf5";
            background = lib.mkForce "#1f2335";
            foreground = lib.mkForce "#c0caf5";
          };
          urgency_normal = {
            frame_color = lib.mkForce "#c0caf5";
            background = lib.mkForce "#24283b";
            foreground = lib.mkForce "#c0caf5";
          };
          urgency_critical = {
            frame_color = lib.mkForce "#db4b4b";
            background = lib.mkForce "#292e42";
            foreground = lib.mkForce "#db4b4b";
          };
        };
      };
    };
  };
}
