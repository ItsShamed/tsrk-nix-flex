# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ config, lib, ... }:

let
  cfg = config.tsrk.kernel.v4l2loopback;
  render =
    v:
    if lib.isString v then
      ''"${v}"''
    else if lib.isList v then
      lib.concatMapStringsSep "," render v
    else
      builtins.toString v;
in
{
  options = {
    tsrk.kernel = {
      v4l2loopback = {
        enable = lib.options.mkEnableOption "the v4l2loopback kernel module";
        moduleOptions = lib.options.mkOption {
          type =
            with lib.types;
            attrsOf (oneOf [
              int
              str
              (listOf (either int str))
            ]);
          description = "Additionnal options to pass to the module";
          default = { };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    boot = {
      kernelModules = [ "v4l2loopback" ];
      extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
      extraModprobeConfig = lib.mkIf (cfg.moduleOptions != { }) ''
        options v4l2loopback ${
          lib.concatMapAttrsStringSep " " (n: v: "${n}=${render v}") cfg.moduleOptions
        }
      '';
    };

    security.polkit.enable = lib.mkDefault true;
  };
}
