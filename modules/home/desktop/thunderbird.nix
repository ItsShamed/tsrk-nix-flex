{ config, lib, ... }:

{
  options = {
    tsrk.thunderbird.enable = lib.options.mkEnableOption "Mozilla Thunderbird";
  };

  config = lib.mkIf config.tsrk.thunderbird.enable {
    programs.thunderbird = {
      enable = lib.mkDefault true;
      profiles."${config.home.username}" = {
        isDefault = true;
      };
    };
  };
}
