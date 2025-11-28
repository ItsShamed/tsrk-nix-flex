# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.tsrk.syshud;
in
{
  options = {
    tsrk.syshud = {
      enable = lib.options.mkEnableOption "syshud as an OSD system";
      package = lib.options.mkPackageOption pkgs "syshud" { default = [ "syshud" ]; };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services = {
      syshud = {
        Unit = {
          Description = "Simple heads up display";
          Documentation = [ "https://github.com/System64fumo/syshud" ];
        };

        Service = {
          ExecStart = "${lib.meta.getExe cfg.package}";
          Restart = "on-failure";
          RestartSec = "5s";
        };

        Install.WantedBy = [ config.wayland.systemd.target ];
      };
    };
  };
}
