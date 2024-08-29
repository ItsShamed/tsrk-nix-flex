{
  description = ''
    Opinionated NixOS base configuration.
  '';

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgsUnstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    futils.url = "github:numtide/flake-utils";
    flake-parts.url = "github:hercules-ci/flake-parts";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    nix-gaming.url = "github:fufexan/nix-gaming";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spotify-notifyx = {
      url = "github:ItsShamed/spotify-dbus-enhancer/master";
    };

    agenix.url = "github:ryantm/agenix";
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgsUnstable

    , futils
    , flake-parts
    , ...
    } @ inputs:
    let
      inherit (nixpkgs) lib;

      importPkgs = pkgs: system: withOverlays:
        import pkgs {
          inherit system;
          config = {
            allowUnfree = true;
            android_sdk.accept_license = true;
          };
          overlays = [
          ] ++ (builtins.attrValues (builtins.removeAttrs (import ./pkgs/as-overlays.nix) [ "all" "default" ]))
          ++ (lib.lists.optionals withOverlays (builtins.removeAttrs (self.overlays) [ "all" "default" ]));
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
            // (import ./profiles/home { inherit lib; })
            // {
            all = import ./modules/home/all.nix;
            default = self.homeManagerModules.all;
          };

          nixvimModules.default = import ./modules/nvim;

          homeConfigurations = import ./homes {
            inherit lib self;
          };

          nixosConfigurations = import ./hosts (lib.recursiveUpdate inputs {
            inherit lib system;
            pkgSet = pkgSet system;
          });
        };
    in
    lib.recursiveUpdate linuxOutputs (flake-parts.lib.mkFlake { inherit inputs; } {

      imports = [ ./flake-modules ];

      systems = futils.lib.defaultSystems;
    });
}
