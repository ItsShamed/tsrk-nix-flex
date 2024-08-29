{ self, inputs, ... }:

{ config, lib, pkgs, ... }:

{

  imports = [
    inputs.nixvim.homeManagerModules.default
  ];

  options = {
    tsrk.nvim = {
      enable = lib.options.mkEnableOption "tsrk's nvim configuration";
      wakatime.enable = lib.options.mkEnableOption "Vim WakaTime";
    };
  };

  config = lib.mkIf config.tsrk.nvim.enable {
    programs.nixvim = { ... }: {
      _module.args.helpers = config.lib.nixvim;
      enable = true;
      defaultEditor = true;

      imports = [
        self.nixvimModules.default
      ];

      tsrk.wakatime.enable = config.tsrk.nvim.wakatime.enable;
    };

    home.file.".ideavimrc".source = ./ideavimrc;
    home.packages = with pkgs; [ fzf ];
  };
}
