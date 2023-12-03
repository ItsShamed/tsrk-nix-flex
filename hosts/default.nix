{ lib
, nixpkgs
, nixpkgsUnstable
, nixpkgsMaster
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
          base = self.nixosModules.profile-base;
          global = {
            system.name = imageName;
            nix.nixPath = [
              "nixpkgs=${nixpkgs}"
              "nixpkgs-unstable=${nixpkgsUnstable}"
              "nixpkgs-master=${nixpkgsMaster}"
            ];

            nix.registry = {
              nixpkgs.flake = nixpkgs;
              nixpkgsUnstable.flake = nixpkgsUnstable;
              nixpkgsMaster.flake = nixpkgsMaster;
            };

            nixpkgs = {
              inherit (pkgSet) pkgs;
            };
          };
          imported = import module;
        in
        [ base global imported ];
    in
    {
      name = imageName;
      value = lib.nixosSystem {
        inherit system modules;
        specialArgs = {
          inherit inputs self;
          host = imageName;
        };
      };
    };
in
builtins.listToAttrs (builtins.map generateSystem (import ./hosts.nix))
