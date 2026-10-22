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

{
  options = {
    tsrk.packages.pkgs.cDev.enable =
      lib.options.mkEnableOption "tsrk's C development bundle";
  };

  config = lib.mkIf config.tsrk.packages.pkgs.cDev.enable {
    environment.systemPackages = with pkgs; [
      autoconf
      autoconf-archive
      automake
      cmake
      gnumake
      makedepend
      meson
      ninja

      gcc

      criterion
      gtest
      gcovr

      clang-tools
      dash
      doxygen
      flex
      gdb
      lcov
      ltrace
      pkg-config
      readline
      tk
      valgrind
      ncurses

      bear

      perlPackages.JSON
      perlPackages.PerlIOgzip
      linuxHeaders
    ];

    environment.variables = {
      NIX_CFLAGS_COMPILE_x86_64_unknown_linux_gnu = "-isystem /run/current-system/sw/include";
      NIX_CFLAGS_LINK_x86_64_unknown_linux_gnu = "-L/run/current-system/sw/lib";

      CMAKE_INCLUDE_PATH = "/run/current-system/sw/include";
      CMAKE_LIBRARY_PATH = "/run/current-system/sw/lib";
      PKG_CONFIG_PATH = "/run/current-system/sw/lib/pkgconfig";
    };
  };
}
