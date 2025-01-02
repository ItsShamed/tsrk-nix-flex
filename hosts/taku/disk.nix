# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
      };
    };
    initrd.luks.devices = {
      cryptlvm.device = "/dev/disk/by-label/cryptlvm";
      crypthome.device = "/dev/disk/by-label/crypthome";
    };
  };

  fileSystems = {
    "/" = {
      label = "ttakuroot";
      fsType = "ext4";
    };
    "/boot" = {
      label = "EFI";
      fsType = "vfat";
    };
    "/home" = {
      label = "ttakuhome";
      fsType = "ext4";
      neededForBoot = true;
    };
  };

  swapDevices = [{ label = "ttakuswap"; }];
}
