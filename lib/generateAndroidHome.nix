{ inputs, ... }:

let
  name = "nix-on-droid";
in

{ modules ? [ ]
}:

{
  home-manager.useGlobalPkgs = true;

  home-manager.config = {
    home.username = name;
    home.stateVersion = "24.05";
    programs.home-manager.enable = true;
  };

  home-manager.sharedModules = modules ++ [ inputs.nixvim.homeManagerModules.nixvim ];
}
