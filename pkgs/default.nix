{ lib, pkgs }:

let
  packageNames = builtins.attrNames (import ./all-packages.nix);

  # This works because we assume that the provided pkgs has been modified by our
  # overlays
  drvs = lib.attrsets.filterAttrs (name: _: builtins.elem name packageNames) pkgs;
in
# We only output packages available for the pkgs' system
lib.attrsets.filterAttrs (_: drv: builtins.elem pkgs.system (drv.meta.platforms)) drvs
