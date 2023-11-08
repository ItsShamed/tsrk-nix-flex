{
  description = ''
    Opinionated NixOS base configuration.
  '';

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    nixpkgsUnstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgsMaster.url = "github:NixOS/nixpkgs/master";

    futils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    epita-forge = {
      url = "git+https://gitlab.cri.epita.fr/cri/infrastructure/nixpie.git";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgsUnstable.follows = "nixpkgsUnstable";
        nixpkgsMaster.follows = "nixpkgsMaster";
      };
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgsUnstable"
    }

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgsUnstable"
    }
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgsUnstable
    , nixpkgsMaster
    , epita-forge
    , nix-gaming
    , futils
    , flake-compat
    , nixos-generators
    , ...
    } @ inputs:
    let
      inherit (nixpkgs) lib;
      inherit (futils.lib) eachDefaultSystem;

      importPkgs = pkgs: system:
        import pkgs {
          inherit system;
          config = { allowUnfree = true; };
        };

      pkgSet = system: {
        pkgs = importPkgs nixpkgs system;
        pkgsUnstable = importPkgs nixpkgsUnstable system;
        pkgsMaster = importPkgs nixpkgsMaster system;
      };

      linuxOutputs =
        let
          system = "x86_64-linux";
        in
        {
          nixosModules = import ./modules/system { inherit lib; };
          lib = import ./lib {
            inherit lib self;
            inherit (pkgSet) pkgsUnstable;
            inherit inputs;
          };
        };

      allOutputs = eachDefaultSystem (system:
        let
          inherit (pkgSet system) pkgs;
        in
        {
          formatter = pkgs.nixpkgs-fmt;
        });
    in
    lib.recursiveUpdate linuxOutputs allOutputs;
}
