{ lib
, nixpkgs
, nixpkgsUnstable
  # , nixpkgsMaster
, pkgSet
, self
, system
, ...
} @ inputs:

let
  generateSystem = module:
    let
      imageName = lib.strings.removeSuffix ".nix" (builtins.baseNameOf module);
      modules =
        let
          global = {
            lib.tsrk.imageName = imageName;
            system.name = imageName;
            nix.nixPath = [
              "nixpkgs=${nixpkgs}"
              "nixpkgs-unstable=${nixpkgsUnstable}"
              # "nixpkgs-master=${nixpkgsMaster}"
              "nixos-config=${self}"
            ];

            nix.registry = {
              nixpkgs.flake = nixpkgs;
              nixpkgsUnstable.flake = nixpkgsUnstable;
              # nixpkgsMaster.flake = nixpkgsMaster;
            };

            nixpkgs = {
              inherit (pkgSet) pkgs;
            };
          };
          imported = import module;
        in
        [ global imported ];
    in
    {
      name = imageName;
      value = lib.nixosSystem {
        inherit system modules;
        specialArgs = {
          inherit inputs self;
          inherit (inputs) home-manager;
          vimHelpers = import "${inputs.nixvim}/lib/helpers.nix" { inherit (inputs.nixpkgs) lib; };
          gaming = inputs.nix-gaming.packages.${system};
          host = imageName;
          agenix = inputs.agenix.packages.${system};
        };
      };
    };
in
builtins.listToAttrs (builtins.map generateSystem (import ./hosts.nix))
