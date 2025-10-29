# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ config, lib, pkgs, ... }:

{
  options = {
    tsrk.packages.media = {
      enable =
        lib.options.mkEnableOption "tsrk's multimedia user package bundle";
    };
  };

  config = lib.mkIf config.tsrk.packages.media.enable {
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        waveform
        wlrobs
        droidcam-obs
        obs-websocket
        obs-webkitgtk
        obs-vkcapture
        obs-3d-effect
        obs-multi-rtmp
        obs-move-transition
        obs-backgroundremoval
        obs-pipewire-audio-capture
      ];
    };

    home.packages = with pkgs; [
      inkscape-with-extensions
      gimp-with-plugins
      kid3
      kdePackages.kdenlive
      tenacity
      vlc
      strawberry
      lollypop
      qbittorrent
      miru
      ffmpeg-full
      imagemagick
      lrcget
      nicotine-plus
    ];
  };
}
