# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  config,
  lib,
  ...
}:

let
  cfg = config.tsrk.meta.externalPackages;
  externalPackageSubmodule = lib.types.submodule (
    { name, config, ... }: {
      options = {
        packages = lib.options.mkOption {
          description = "The group of packages to make available to modules and foreign consumers";
          type = with lib.types; (either package (listOf package));
          readOnly = true;
          example = lib.literalExpression ''
            pkgs.hello
          '';
          apply = pkg: if !builtins.isList pkg then [ pkg ] else pkg;
        };
        firstPackage = lib.options.mkOption {
          description = "The first package of this group.";
          type = lib.types.package;
          readOnly = true;
        };
        install = lib.options.mkEnableOption "the installation of the group ${name} as external packages";
      };

      config = {
        firstPackage = builtins.head config.packages;
      };
    }
  );
  installedPackages = lib.flatten (
    lib.mapAttrsToList (_: pkg: pkg.packages) (
      lib.filterAttrs (_: pkg: pkg.install) cfg
    )
  );
in
{
  key = ./. + "external-packages.nix";
  imports = [
    (lib.mkAliasOptionModule
      [ "tsrk" "extPkgs" ]
      [ "tsrk" "meta" "externalPackages" ]
    )
  ];

  options = {
    tsrk.meta = {
      externalPackages = lib.options.mkOption {
        description = ''
          Group of packages provided from an source external to the module
          system (typically a Nix Flake for example). This allow foreign
          consumers of this module and definitions of this module to install
          packages without having to rely on extra module arguments and abuse
          of a flake's "self-insertion" (like literally). Typically packages
          behind an overlay, or from a flake's output.
        '';
        type = with lib.types; attrsOf externalPackageSubmodule;
        example = lib.literalExpression ''
          {
            // Assume self is the attribute referencing an external flake
            doukutsu-rs =
              self.packages.''${pkgs.stdenv.hostPlatform.system}.doukutsu-rs;
          }
        '';
      };
    };
  };

  config = {
    home.packages = installedPackages;
  };
}
