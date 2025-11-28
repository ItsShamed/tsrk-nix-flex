# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, ... }:

{ config, lib, ... }:

let
  cfg = config.tsrk.networking.hostname;
  host = config.lib.tsrk.imageName or null;
in
{
  options = {
    tsrk.networking.hostname = {
      enable = (lib.options.mkEnableOption "custom hostname options") // {
        default = true;
      };
      useDHCPHostname = lib.options.mkOption {
        type = lib.types.bool;
        description = "Whether to use the hostname provided by DHCP.";
        default = false;
      };
      base = lib.options.mkOption {
        type = lib.types.str;
        description = "The base hostname to use.";
        default = "tsrk";
      };
      removeImageSuffix = lib.options.mkOption {
        type = lib.types.bool;
        description = "Whether to remove the suffix identifying the host you are using.";
        default = false;
      };
    };
  };

  config = (
    lib.mkIf cfg.enable (
      self.lib.mkIfElse cfg.useDHCPHostname { networking.hostName = ""; } {
        assertions = [
          {
            assertion = host != null;
            message = "Please set `lib.tsrk.imageName' in your config, othewrise set `tsrk.networking.hostname.enable' to false.";
          }
        ];
        networking.hostName =
          cfg.base + (lib.strings.optionalString (!cfg.removeImageSuffix) ("-" + host));
      }
    )
  );
}
