{ pkgs, config, lib, ... }:

{
  options = {
    tsrk.nvim = {
      wakatime.enable = lib.options.mkEnableOption "Wakatime plugin";
    };
  };

  config = lib.mkIf config.tsrk.nvim.wakatime.enable {
    programs.nixvim = {
      extraPlugins = with pkgs; [
        vimPlugins.vim-wakatime
      ];
    };
  };
}
