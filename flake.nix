{
  description = ''
    Opinionated NixOS base configuration.
  '';

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgsUnstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # nixpkgsMaster.url = "github:NixOS/nixpkgs/master";

    futils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
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
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix.url = "github:ryantm/agenix";
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgsUnstable
      # , nixpkgsMaster

    , nix-gaming
    , futils
    , flake-compat
    , nixos-generators

    , home-manager
    , nixvim

    , agenix
    , ...
    } @ inputs:
    let
      inherit (nixpkgs) lib;
      inherit (futils.lib) eachDefaultSystem;

      importPkgs = pkgs: system: withOverlays:
        import pkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
          overlays = [

          ] ++ (lib.lists.optionals withOverlays (import ./overlays));
        };

      pkgSet = system: {
        pkgs = importPkgs nixpkgs system true;
        pkgsUnstable = importPkgs nixpkgsUnstable system false;
        # pkgsMaster = importPkgs nixpkgsMaster system false;
      };

      linuxOutputs =
        let
          system = "x86_64-linux";
        in
        {
          nixosModules = (import ./modules/system { inherit lib; })
            // (import ./profiles/system { inherit lib; })
            // {
            all = import ./modules/system/all.nix;
            default = self.nixosModules.all;
          };

          homeManagerModules = (import ./modules/home { inherit lib; })
            // {
            all = import ./modules/home/all.nix;
            default = self.homeModules.all;
          };

          lib = import ./lib {
            inherit lib self;
            pkgSet = pkgSet system;
            inherit inputs;
          };

          homeConfigurations = import ./homes {
            inherit lib self;
          };

          nixosConfigurations = import ./hosts (lib.recursiveUpdate inputs {
            inherit lib system;
            pkgSet = pkgSet system;
          });
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
