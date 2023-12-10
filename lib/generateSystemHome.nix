{ self, inputs, pkgSet, ... }:

name:

{ modules ? [ ]
, system ? "x86_64-linux"
, homeDir ? "/home/${name}"
}:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  home-manager.useGlobalPkgs = true;

  home-manager.users."${name}" = {
    imports = modules ++ [
      inputs.nixvim.homeManagerModules.nixvim
    ];
    home.username = name;
    home.homeDirectory = homeDir;
    home.stateVersion = "23.11";
    programs.home-manager.enable = true;
  };

  home-manager.extraSpecialArgs = {
    inherit self;
    inherit inputs;
    inherit (inputs) home-manager;
    vimHelpers = import "${inputs.nixvim}/lib/helpers.nix" { inherit (inputs.nixpkgsUnstable) lib; };
    gaming = inputs.nix-gaming.packages.${system};
  };
}
