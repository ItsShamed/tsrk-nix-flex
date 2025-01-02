# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ config, lib, pkgs, ... }:

{
  options = {
    tsrk.packages.pkgs.rust = {
      enable = lib.options.mkEnableOption "tsrk's Rust bundle";
    };
  };

  config = lib.mkIf config.tsrk.packages.pkgs.rust.enable {
    environment.systemPackages = with pkgs; [
      cargo
      rustc
      rustup
      rustfmt
      clippy
    ];
  };
}
