# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ config, lib, ... }:

let cfg = config.tsrk.waybar;
in {
  options = {
    tsrk.waybar = {
      # style: keep unwrapped
      enable = lib.options.mkEnableOption "tsrk's Waybar configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = lib.mkDefault true;
      systemd.enable = lib.mkDefault true;
      settings = {
        main = {
          layer = "top";
          height = 40;
          modules-left =
            [ "hyprland/workspaces" "hyprland/submap" "hyprland/window" ];
          modules-center = [ "cava" ];
          modules-right =
            [ "network" "battery" "backlight" "pulseaudio" "clock" "tray" ];

          "hyprland/workspaces" = {
            format = "{icon}{id}";
            format-icons = {
              workdir = "  ";
              tooling = "󰆍  ";
              web = "󰖟  ";
              coms = "󰭹  ";
              default = "";
            };
          };

          cava = {
            method = "pipewire";
            stereo = false;
            higher_cutoff_freq = 5000;
            hide_on_silence = true;
          };

          "hyprland/submap".tooltip = false;

          network = {
            interval = 1;
            family = "ipv4_6";
            format = " {ifname}";
            format-ethernet = "{icon} {ipaddr}";
            format-wifi = "{icon} {essid}";
            format-linked = "{icon} {ifname}のIPが待ち受けます";
            format-disconnected = "";
            format-icons = {
              linked = "󱖣 ";
              ethernet = "󰈁";
              wifi = [ "󰤯 " "󰤟 " "󰤢 " "󰤥 " "󰤨 " ];
            };
            tooltip-format-ethernet = ''
              {icon} Interface {ifname}
              {ipaddr}/{cidr} via {gwaddr}

              ネットマスク: {netmask}

              Up: {bandwidthUpBits} ({bandwidthUpBytes})
              Down: {bandwidthDownBits} ({bandwidthDownBytes})'';
            tooltip-format-wifi = ''
              {icon} {ifname} on {essid}
              {ipaddr}/{cidr} via {gwaddr}
              Signal: {signaldBm} ({signalStrength}%)

              ネットマスク: {netmask}

              Up: {bandwidthUpBits} ({bandwidthUpBytes})
              Down: {bandwidthDownBits} ({bandwidthDownBytes})'';
          };

          battery = {
            interval = 1;
            states = {
              ok = 90;
              warning = 20;
              critical = 10;
            };
            format = "{icon} {capacity}%";
            format-icons = {
              warning = "󱃍 ";
              critical = "󱉞 ";
              default-charging =
                [ "󰢜 " "󰢜 " "󰂇 " "󰂈 " "󰢝 " "󰂉 " "󰢞 " "󰂊 " "󰂋 " "󰂅 " ];
              default = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
            };
          };

          backlight = {
            format = "{icon} {percent}%";
            format-icons = [ "󰃚 " "󰃛 " "󰃜" "󰃝 " "󰃞 " "󰃟 " "󰃠 " ];
          };

          pulseaudio = {
            format = "{icon} {volume}%";
            format-bluetooth = "{icon} {volume}%";
            format-muted = "{icon} <span color='#e0af68'>--%</span>";
            format-icons = {
              phone = " ";
              phone-off = "󰷯 ";
              headset-muted = "󰟎 ";
              headset = "󰋋 ";
              hdmi-muted = "󰠻 ";
              hdmi = "󰔂 ";
              default-muted = "󰝟 ";
              default = [ "󰕿" "󰖀" "󰕾 " ];
            };
          };

          clock = {
            format = "  {:%I:%M:%S %p}";
            format-alt = "  {:%Y-%m-%d %I:%M:%S %p}";
            tooltip = true;
            tooltip-format = "<tt><small>{calendar}</small></tt>";
            interval = 1;
            calendar = {
              mode = "month";
              mode-mon-col = 4;
              on-scroll = 1;
              format = {
                months = "<b>{}</b>";
                days = "<span color='#a9b1d6'>{}</span>";
                weekdays = "<span color='#3b4261'><b>{}</b></span>";
                today = "<span color='#f7768e'><b><u>{}</u></b></span>";
              };
            };
            actions = {
              on-click-right = "mode";
              on-scroll-down = "shift_down";
              on-scroll-up = "shift_up";
            };
          };

          tray = {
            spacing = 6;
            icon-size = 16;
          };
        };
      };
      style = "${builtins.readFile ./style.css}";
    };
  };
}
