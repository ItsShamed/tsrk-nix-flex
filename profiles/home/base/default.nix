{ self, ... }:

{ lib, ... }:

{
  key = ./.;

  imports = with self.homeManagerModules; [ packages nvim git shell ];

  config = {
    tsrk.packages.core.enable = lib.mkDefault true;
    tsrk.shell = {
      bash.enable = lib.mkDefault true;
      bat.enable = lib.mkDefault true;
      direnv.enable = lib.mkDefault true;
      enableViKeybinds = lib.mkDefault true;
      fastfetch.enable = lib.mkDefault true;
      lsd.enable = lib.mkDefault true;
      starship.enable = lib.mkDefault true;
      zoxide.enable = lib.mkDefault true;
      zsh.enable = lib.mkDefault true;
    };
    tsrk.git = {
      enable = lib.mkDefault true;
      cli.enable = lib.mkDefault true;
      delta.enable = lib.mkDefault true;
      lazygit.enable = lib.mkDefault true;
    };
    tsrk.nvim.enable = lib.mkDefault true;
  };
}
