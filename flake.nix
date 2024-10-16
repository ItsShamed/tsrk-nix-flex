{
  description = ''
    Opinionated NixOS base configuration.
  '';

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgsUnstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # nixpkgsMaster.url = "github:NixOS/nixpkgs/master";

    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    futils.url = "github:numtide/flake-utils";
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

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
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
      # , nixpkgsMaster
    , nixgl

    , futils
    , nixvim
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
            android_sdk.accept_license = true;
          };
          overlays = [
            nixgl.overlay
          ] ++ (builtins.attrValues (builtins.removeAttrs (import ./pkgs/as-overlays.nix) [ "all" "default" ]))
          ++ (lib.lists.optionals withOverlays (builtins.attrValues (import ./overlays { inherit lib; })));
        };

      pkgSet = system: {
        pkgs = importPkgs nixpkgs system true;
        pkgsUnstable = importPkgs nixpkgsUnstable system false;
        # pkgsMaster = importPkgs nixpkgsMaster system false;
      };

      linuxOutputs =
        let
          system = "x86_64-linux";
          baseOverlays = (import ./pkgs/as-overlays.nix) // (import ./overlays { inherit lib; });
          allOverlays = self: super: builtins.attrValues (
            builtins.mapAttrs (_: overlay: overlay self super) baseOverlays
          );
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

          lspHints = import ./lsp-hints.nix { inherit lib self inputs; };

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

          overlays = baseOverlays
            // {
            all = allOverlays;
            default = self.overlays.all;
          };
        };

      androidOutputs =
        let
          system = "aarch64-linux";
        in
        {
          nixOnDroidModules = (import ./modules/android { inherit lib; })
            // (import ./profiles/android { inherit lib; })
            // {
            all = import ./modules/android/all.nix;
            default = self.nixOnDroidModules.all;
          };

          nixOnDroidConfigurations = import ./droids (lib.recursiveUpdate inputs {
            inherit lib;
            pkgSet = pkgSet system;
          });
        };

      allOutputs = eachDefaultSystem (system:
        let
          inherit (pkgSet system) pkgs;
        in
        {
          formatter = pkgs.nixpkgs-fmt;
          packages = (import ./pkgs { inherit lib pkgs; }) // {
            nvim-cirno = nixvim.legacyPackages.${system}.makeNixvimWithModule {
              inherit pkgs;
              module = self.nixvimModules.default;
            };
          };
        });
    in
    lib.recursiveUpdate (lib.recursiveUpdate linuxOutputs allOutputs) androidOutputs;
}
