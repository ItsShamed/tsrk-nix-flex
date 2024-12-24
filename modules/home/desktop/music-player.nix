# Copyright (c) 2024 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ config, lib, pkgs, ... }:

let cfg = config.tsrk.music-player;
in {
  options = {
    tsrk.music-player = {
      enable = lib.options.mkEnableOption "the music-player daemon";
      package = lib.options.mkPackageOption pkgs "music-player" {
        default = [ "music-player" ];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    systemd.user.services = {
      music-player = {
        Unit = {
          Requires = "pipewire.socket";
          After = "music-player-scan.service";
          Description = "Music-player daemon";
        };

        Service = { ExecStart = "${lib.meta.getExe cfg.package}"; };

        Install.WantedBy = [ "default.target" ];
      };
      music-player-scan = {
        Unit = {
          Requires = "pipewire.socket";
          Description = "Music-player local files scan";
        };

        Service = {
          ExecStart = "${lib.meta.getExe cfg.package} scan";
          Type = "oneshot";
        };

        Install.WantedBy = [ "default.target" ];
      };
    };
  };
}
