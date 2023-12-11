{ config, lib, pkgs, ... }:

{
  options = {
    tsrk.packages.pkgs.cDev.enable = lib.options.mkEnableOption "tsrk's C development bundle";
  };

  config = lib.mkIf config.tsrk.packages.pkgs.cDev.enable {
    environment.systemPackages = with pkgs; [
      autoconf
      autoconf-archive
      automake
      cmake
      gnumake
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

      perlPackages.JSON
      perlPackages.PerlIOgzip
    ];
  };
}
