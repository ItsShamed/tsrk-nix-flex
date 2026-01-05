# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.tsrk.libvirt;
in
{
  options = {
    tsrk.libvirt = {
      enable = lib.options.mkEnableOption "libvirt";
      spice.enable = lib.options.mkEnableOption "SPICE";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        virtualisation.libvirtd = {
          enable = true;
          qemu = {
            runAsRoot = true;
            swtpm.enable = true;
          };
        };

        programs.virt-manager.enable = lib.mkDefault true;

        environment.systemPackages = with pkgs; [ libguestfs ];
      }
      (lib.mkIf cfg.spice.enable {
        environment.systemPackages = with pkgs; [
          spice
          spice-gtk
        ];
      })
    ]
  );
}
