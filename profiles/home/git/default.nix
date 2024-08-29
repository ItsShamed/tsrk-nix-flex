{ localModules, ... }:

{ lib, ... }:

{
  imports = with localModules; [
    default
    git
    git-cli
    lazygit
  ];

  config = {
    tsrk.git = {
      enable = lib.mkDefault true;
      cli.enable = lib.mkDefault true;
      delta.enable = lib.mkDefault true;
      lazygit.enable = lib.mkDefault true;
    };
  };
}
