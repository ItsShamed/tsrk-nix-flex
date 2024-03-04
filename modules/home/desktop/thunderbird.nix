{ config, lib, pkgs, ... }:

{
  programs.thunderbird = {
    enable = lib.mkDefault true;
    profiles."${config.home.username}" = {
      isDefault = true;
    };
  };
}
