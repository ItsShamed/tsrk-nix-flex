{ config, lib, ... }:

{
  options = {
    tsrk = {
      wakatime.enable = lib.options.mkEnableOption "Wakatime plugin";
    };
  };

  config = lib.mkIf config.tsrk.wakatime.enable {
    plugins.vim-wakatime = {
      enable = true;
    };
  };
}
