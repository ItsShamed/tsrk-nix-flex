# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ inputs, ... }:

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.tsrk.pano-scrobbler;
  pano-scrobbler =
    inputs.pano-scrobbler.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  options = {
    tsrk = {
      pano-scrobbler = {
        enable = lib.options.mkEnableOption "Pano Scrobbler";
        package = lib.options.mkOption {
          description = "The package to use for Pano Scrobbler";
          type = lib.types.package;
          default = pano-scrobbler;
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.pano-scrobbler = {
      Unit = {
        Description = "Pano Scrobbler";
        PartOf = [ "graphical-session.target" ];
      };

      Install.WantedBy = [ "graphical-session.target" ];
      Service = {
        Type = "exec";
        ExecStart = "${lib.getExe cfg.package} --minimized";
        Restart = "on-failure";
      };
    };

    home.packages = [ cfg.package ];
  };
}
