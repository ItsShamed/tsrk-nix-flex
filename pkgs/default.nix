{ lib, pkgs, system }:

let
  topLevelPackages = import ./all-packages.nix;

  mkCallPackage = pkgDecl: pkgs:
    (pkgDecl.callPackage pkgs) pkgDecl.path (pkgDecl.args pkgs);

  getPlatforms = drv:
    if drv ? meta && drv.meta ? platforms then
      drv.meta.platforms
    else
      lib.platforms.all;

  isCompatibleWithSystem = _: drv: builtins.elem system (getPlatforms drv);

  pkgToDrv = name: pkgArgs:
    let
      defaultArgs = {
        callPackage = pkgs: pkgs.callPackage;
        args = pkgs: { };
      };

      pkgDecl =
        if builtins.isAttrs pkgArgs then
          (defaultArgs // pkgArgs)
        else
          defaultArgs // { path = pkgArgs; };

      overrideDecl = args: pkgDecl // { args = _: args; };
    in
    (mkCallPackage pkgDecl pkgs) // {
      override = args: mkCallPackage (overrideDecl args) pkgs;
    };

  allDrvs = builtins.mapAttrs pkgToDrv topLevelPackages;
in
lib.attrsets.filterAttrs isCompatibleWithSystem allDrvs
