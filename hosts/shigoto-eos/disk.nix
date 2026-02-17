# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ pkgs, ... }:

{
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = false;
      grub.enable = false;
      limine = {
        enable = true;
        additionalFiles = {
          "efi/memtest86plus/memtest86plus.efi" = "${pkgs.memtest86plus}/mt86plus.efi";
          "efi/netboot-xyz/netboot.efi" = "${pkgs.netbootxyz-efi}";
        };
        extraEntries = ''
          /Tools
          //Netboot.xyz
            comment: ${pkgs.netbootxyz-efi.meta.description}
            protocol: efi
            path: boot():/limine/efi/netboot-xyz/netboot.efi
          //Memtest86+
            comment: ${pkgs.memtest86plus.meta.description}
            protocol: efi
            path: boot():/limine/efi/memtest86plus/memtest86plus.efi
        '';
        panicOnChecksumMismatch = true;
      };
    };
  };
  zramSwap.enable = true;
  disko.devices = {
    disk = {
      skhynix = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-SKHynix_HFS512GEM9X169N_5JE9N445710609D0G";
        content = {
          type = "gpt";
          partitions = {
            EFI = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              }; # /boot
            }; # EFI
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "cryptbtrfs";
                extraOpenArgs = [ ];
                settings = {
                  keyFile = "/tmp/secret.key";
                  allowDiscards = true;
                };
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    }; # /root
                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    }; # /home
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    }; # /nix
                    "/swap" = {
                      mountpoint = "/.swapvol";
                      swap.swapfile.size = "20M";
                    }; # /swap
                  }; # Subvolumes
                }; # btrfs
              }; # LUKS content
            }; # luks partition
          }; # partitions
        }; # disk contents
      }; # skhynix disk
    }; # disks
  }; # disko
}
