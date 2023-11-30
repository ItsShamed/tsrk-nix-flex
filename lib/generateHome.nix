{ self, inputs, pkgSet, ... }:

name:

{ modules ? [ ]
, system ? "x86_64-linux"
, homeDir ? "/home/${name}"
}:

let
  homeManagerBase = { ... }: {
    home.username = name;
    home.homeDirectory = homeDir;
    home.stateVersion = "23.11";
    programs.home-manager.enable = true;
  };

  configuration = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = pkgSet.pkgs;

    modules = modules ++ [
      self.homeModules
      homeManagerBase
      inputs.nixvim.homeManagerModules.nixvim
    ];

    extraSpecialArgs = {
      inherit self;
      vimHelpers = import "${inputs.nixvim}/lib/helpers.nix" { inherit (inputs.nixpkgsUnstable) lib; };
      gaming = inputs.nix-gaming.packages.${system};
    };
  };
in
configuration
