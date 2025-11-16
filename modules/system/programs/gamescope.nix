# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ config, lib, pkgs, ... }:

let
  cfg = config.tsrk.programs.gamescope;
  mockSessionSelect = pkgs.writeShellScriptBin "steamos-session-select" ''
    steam -shutdown
  '';

  steamGamescopeDesktop = pkgs.makeDesktopItem {
    name = "steam-gamescope";
    desktopName = "Steam GameScope";
    exec = "steam-gamescope %U";
    icon = "steam";
    terminal = false;
    categories = [ "Network" "FileTransfer" "Game" ];
    prefersNonDefaultGPU = true;
  };
in {
  options = {
    tsrk.programs.gamescope = {
      enable = lib.options.mkEnableOption "Valve gamescope";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ steamGamescopeDesktop ];
    programs.steam.gamescopeSession = {
      enable = lib.mkDefault true;
      args = [
        "--output-width 1920"
        "--output-height 1080"
        "--nested-width 1920"
        "--nested-height 1080"
        "--fullscreen"
      ];
      steamArgs = [ "-steamos3" "-tenfoot" "-pipewire-dmabuf" ];
      env.PATH = ''"${mockSessionSelect}/bin:$PATH"'';
    };
  };
}
