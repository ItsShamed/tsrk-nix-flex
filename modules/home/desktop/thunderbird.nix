{ config, lib, pkgs, ... }:

{
  options = {
    tsrk.thunderbird.enable = lib.options.mkEnableOption "Mozilla Thunderbird";
  };

  config = lib.mkIf config.tsrk.thunderbird.enable {
    programs.thunderbird = {
      enable = lib.mkDefault true;
      package = pkgs.betterbird;
      profiles."${config.home.username}" = {
        isDefault = true;
      };
    };
  };
}
