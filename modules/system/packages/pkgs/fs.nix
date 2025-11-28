# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    tsrk.packages.pkgs.fs.enable =
      lib.options.mkEnableOption "tsrk's filesystem package bundle";
  };

  config = lib.mkIf config.tsrk.packages.pkgs.fs.enable {
    environment.systemPackages = with pkgs; [
      fuse
      fuse3
      fuseiso
      sshfs

      ntfs3g # To transfer Windows backups
    ];
  };
}
