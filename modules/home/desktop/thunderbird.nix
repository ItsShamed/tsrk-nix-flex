{ config, lib, pkgs, ... }:

{
  programs.thunderbird = {
    enable = lib.mkDefault true;
    profiles."${config.home.username}" = {
      name = config.home.username;
      isDefault = true;
    };
  };
}
