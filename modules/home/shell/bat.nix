{ config, lib, pkgs, ... }:

{
  programs.bat = {
    enable = true;
  };

  specialisation = {
    light.configuration = {
      programs.bat.config.theme = "OneHalfLight";
    };
    dark.configuration = {
      programs.bat.config.theme = "OneHalfDark";
    };
  };
}
