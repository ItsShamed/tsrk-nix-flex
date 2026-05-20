# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  lib,
  options,
  config,
  ...
}:

let
  cfg = config.ws1-hub;
in
{
  _class = "service";
  options = {
    ws1-hub = {
      package = lib.options.mkOption {
        description = "Package to use for the Workspace ONE Intelligent Hub Agent";
        type = lib.types.package;
      };
    };
  };

  config = {
    process.argv = [
      "${cfg.package}/bin/ws1HubAgent"
    ];
  }
  // lib.optionalAttrs (options ? systemd) {
    systemd.service = {
      after = [ "network.target" ];
      preStop = ''
        ${lib.getExe cfg.package} service --stop
      '';
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = "5s";
        KillMode = "process";
      };
    };
  };
}
