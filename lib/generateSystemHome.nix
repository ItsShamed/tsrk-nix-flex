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

  configuration = inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = false;

      home-manager."${name}" = {
        imports = modules ++ [
          self.homeModules
          homeManagerBase
          inputs.nixvim.homeManagerModules.nixvim
        ];
        nixpkgs = pkgSet.pkgs;
      };

      extraSpecialArgs = {
        inherit self;
        vimHelpers = import "${inputs.nixvim}/lib/helpers.nix" { inherit (inputs.nixpkgsUnstable) lib; };
        gaming = inputs.nix-gaming.packages.${system};
      };
    };
in
configuration
