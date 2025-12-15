{
  lib,
  overlays ? { },
}:

lib.mapAttrs' (n: v: {
  name = "overlay-" + n;
  value = {
    _file = ./overlays-as-modules.nix;
    key = ./overlays-as-modules.nix + "-overlay-${n}";

    nixpkgs.overlays = [ v ];
  };
}) overlays
