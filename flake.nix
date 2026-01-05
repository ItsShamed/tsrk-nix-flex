# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  description = ''
    Opinionated NixOS base configuration.
  '';

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
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
    flake-programs-sqlite = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming.url = "github:fufexan/nix-gaming";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    nixos-hardware = {
      url = "github:nixos/nixos-hardware";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim.url = "github:nix-community/nixvim/nixos-25.11";

    agenix.url = "github:ryantm/agenix";
    git-hooks.url = "github:cachix/git-hooks.nix";

    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgsUnstable,
      # , nixpkgsMaster
      nixgl,

      futils,
      nixvim,
      git-hooks,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;
      inherit (futils.lib) eachDefaultSystem;
      commonArgs = {
        inherit
          lib
          self
          inputs
          pkgSet
          ;
      };

      importPkgs =
        pkgs: system: withOverlays:
        import pkgs {
          inherit system;
          config = {
            allowUnfree = true;
            android_sdk.accept_license = true;
            # TODO: OpenRGB wake the fuck up
            permittedInsecurePackages = [ "mbedtls-2.28.10" ];
          };
          overlays = [
            nixgl.overlay
          ]
          ++ (builtins.attrValues (
            builtins.removeAttrs (import ./pkgs/as-overlays.nix) [
              "all"
              "default"
            ]
          ))
          ++ (lib.lists.optionals withOverlays (
            builtins.attrValues (import ./overlays commonArgs)
          ));
        };

      pkgSet = system: {
        pkgs = importPkgs nixpkgs system true;
        pkgsUnstable = importPkgs nixpkgsUnstable system false;
        # pkgsMaster = importPkgs nixpkgsMaster system false;
      };

      linuxOutputs =
        let
          system = "x86_64-linux";
          baseOverlays =
            (import ./pkgs/as-overlays.nix) // (import ./overlays commonArgs);
          allOverlays =
            self: super:
            builtins.attrValues (
              builtins.mapAttrs (_: overlay: overlay self super) baseOverlays
            );
        in
        {
          nixosModules =
            (import ./modules/system commonArgs)
            // (import ./modules/overlays-as-modules.nix {
              inherit lib;
              inherit (self) overlays;
            })
            // (import ./profiles/system commonArgs)
            // {
              all = lib.modules.importApply ./modules/system/all.nix commonArgs;
              default = self.nixosModules.all;
            };

          homeManagerModules =
            (import ./modules/home commonArgs)
            // (import ./modules/overlays-as-modules.nix {
              inherit lib;
              inherit (self) overlays;
            })
            // (import ./profiles/home commonArgs)
            // {
              all = lib.modules.importApply ./modules/home/all.nix commonArgs;
              default = self.homeManagerModules.all;
            };

          nixvimModules.default = lib.modules.importApply ./modules/nvim commonArgs;

          lspHints = import ./lsp-hints.nix commonArgs;

          lib = import ./lib {
            inherit
              lib
              self
              pkgSet
              inputs
              ;
          };

          homeConfigurations = import ./homes { inherit lib self; };

          nixOnDroidConfigurations = import ./android (
            lib.recursiveUpdate inputs {
              inherit lib inputs;
              system = "aarch64-linux";
              pkgSet = pkgSet "aarch64-linux";
            }
          );

          nixosConfigurations = import ./hosts (
            lib.recursiveUpdate inputs {
              inherit lib system;
              pkgSet = pkgSet system;
            }
          );

          overlays = baseOverlays // {
            all = allOverlays;
            default = self.overlays.all;
          };
        };

      allOutputs = eachDefaultSystem (
        system:
        let
          inherit (pkgSet system) pkgs;
        in
        {
          formatter =
            let
              config = self.checks.${system}.pre-commit-check.config;
              inherit (config) package configFile;
            in
            pkgs.writeShellScriptBin "pre-commit-run" ''
              ${lib.getExe package} run --all-files --config ${configFile}
            '';

          checks.pre-commit-check = git-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              deadnix = {
                enable = true;
                settings = {
                  edit = true;
                  noUnderscore = true;
                };
              };
              nixfmt = {
                enable = true;
                settings.width = 80;
              };
            };
          };

          packages = (import ./pkgs { inherit lib pkgs; }) // {
            nvim-cirno = nixvim.legacyPackages.${system}.makeNixvimWithModule {
              inherit pkgs;
              module = self.nixvimModules.default;
            };
          };

          devShells.default =
            let
              packages = with pkgs; [
                nix-output-monitor
                eww
                nh
                playerctl
                nixfmt
                inputs.agenix.packages.${system}.default
              ];

              forwardScript =
                path:
                pkgs.writeShellApplication {
                  name = lib.strings.removeSuffix ".sh" (builtins.baseNameOf "${path}");
                  runtimeInputs = packages;
                  text = ''
                    exec ${path} "$@"
                  '';
                };

              scriptPackages = builtins.map forwardScript [
                "${self}/bump-copyright-years.sh"
                "${self}/gc.sh"
                "${self}/get_option.sh"
                "${self}/rebuild-os.sh"
                "${self}/rotate_bootstrap_keys.sh"
                "${self}/run-vm.sh"
              ];

              scripts = pkgs.symlinkJoin {
                name = "tsrk-scripts";
                paths = scriptPackages;
              };
              inherit (self.checks.${system}.pre-commit-check)
                shellHook
                enabledPackages
                ;
            in
            pkgs.mkShellNoCC {
              name = "tsrk";
              inherit shellHook;
              buildInputs = enabledPackages ++ packages ++ [ scripts ];
              packages = packages ++ [ scripts ];
            };
        }
      );
    in
    lib.recursiveUpdate linuxOutputs allOutputs;
}
