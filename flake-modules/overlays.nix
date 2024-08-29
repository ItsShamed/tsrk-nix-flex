{ lib, self, ... }:

let
  baseOverlays = (import ../pkgs/as-overlays.nix) // (import ../overlays { inherit lib; });
in
{
  flake.overlays = baseOverlays // {
    all = self: super: builtins.attrValues (
      builtins.mapAttrs (_: overlay: overlay self super) baseOverlays
    );
    default = self.overlays.all;
  };
}
