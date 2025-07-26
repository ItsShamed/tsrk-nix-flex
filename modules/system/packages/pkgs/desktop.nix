# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ config, lib, pkgs, ... }:

{
  options = {
    tsrk.packages.pkgs.desktop.enable =
      lib.options.mkEnableOption "tsrk's desktop bundle";
  };

  config = lib.mkIf config.tsrk.packages.pkgs.desktop.enable {
    environment.systemPackages = with pkgs; [
      # communication
      weechat

      # images
      feh
      imagemagick
      scrot

      # Browsers
      librewolf
      firefox
      ungoogled-chromium

      # video
      mpv

      # cli
      kitty
      dialog

      # X.Org
      xclip
      xsel
      x11vnc
      lxappearance

      # Wayland
      wl-clipboard
    ];

    xdg.mime.defaultApplications = {
      "application/pdf" = [ "librewolf.desktop" "firefox.desktop" ];
      "x-scheme-handler/http" = [ "librewolf.desktop" "firefox.desktop" ];
      "x-scheme-handler/https" = [ "librewolf.desktop" "firefox.desktop" ];
      "text/html" = [ "librewolf.desktop" "firefox.desktop" ];
      "application/xhtml+xml" = [ "librewolf.desktop" "firefox.desktop" ];
      "application/xhtml_xml" = [ "librewolf.desktop" "firefox.desktop" ];
    };
  };
}
