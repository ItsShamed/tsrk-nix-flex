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
    home.stateVersion = "24.05";
    programs.home-manager.enable = true;
  };

  home-manager.extraSpecialArgs = {
    inherit self;
    inherit inputs;
    inherit (inputs) home-manager;
    inherit (pkgSet) pkgsUnstable;
    hmLib = inputs.home-manager.lib.hm;
    vimHelpers = import "${inputs.nixvim}/lib/helpers.nix" {
      inherit (inputs.nixpkgs) lib;
      inherit (pkgSet) pkgs;
      _nixvimTests = false;
    };
    gaming = inputs.nix-gaming.packages.${system};
  };
}
