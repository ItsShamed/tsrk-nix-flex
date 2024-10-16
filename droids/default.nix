{ lib
, nixpkgs
, nixpkgsUnstable
  # , nixpkgsMaster
, pkgSet
, self
, nix-on-droid
, home-manager
, ...
} @ inputs:

let
  generateDroid = module:
    let
      imageName = lib.strings.removeSuffix ".nix" (builtins.baseNameOf module);
      modules =
        let
          global = {
            nix.nixPath = [
              "nixpkgs=${nixpkgs}"
              "nixpkgs-unstable=${nixpkgsUnstable}"
              # "nixpkgs-master=${nixpkgsMaster}"
              "nix-on-droid-config=${self}"
            ];

            nix.registry = {
              nixpkgs.flake = nixpkgs;
              nixpkgsUnstable.flake = nixpkgsUnstable;
              # nixpkgsMaster.flake = nixpkgsMaster;
            };

            nixpkgs = {
              inherit (pkgSet.pkgs) config overlays;
            };
          };
          imported = import module;
        in
        [ global imported ];
    in
    {
      name = imageName;
      value = nix-on-droid.lib.nixOnDroidConfiguration {
        inherit modules;
        inherit (pkgSet) pkgs;
        home-manager-path = home-manager.outPath;
        extraSpecialArgs = {
          inherit inputs self;
          inherit (inputs) home-manager;
          vimHelpers = import "${inputs.nixvim}/lib/helpers.nix" { inherit (inputs.nixpkgs) lib; };
          host = imageName;
        };
      };
    };
in
builtins.listToAttrs (builtins.map generateDroid (import ./droids.nix))
