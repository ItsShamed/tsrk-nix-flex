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

      importPkgs = pkgs: system: useOverrides:
        import pkgs {
          inherit system;
          config = { allowUnfree = true; };
          overlays =
            (lib.attrValues self.overlays)
            ++ (lib.optional useOverrides self.overrides.${system});
        };

      pkgSet = system: {
        pkgs = importPkgs nixpkgs system true;
        pkgsUnstable = importPkgs nixpkgsUnstable system false;
        pkgsMaster = importPkgs nixpkgsMaster system false;
      };

      linuxOutputs =
        let
          system = "x86_64-linux";
        in
        { nixosModules = import ./modules/system { inherit lib; }; };

      allOutputs = eachDefaultSystem (system: { });
    in
    lib.recursiveUpdate linuxOutputs allOutputs;
}
