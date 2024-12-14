{ self, ... }:

{ lib, config, ... }:

let
  host = config.lib.tsrk.imageName or
    (lib.warn
      "`lib.tsrk.imageName' was not specified, will be using 'unknown'"
      "unknown");
in
{
  key = ./.;

  imports = with self.nixosModules; [
    profile-base
  ];

  isoImage.isoName = lib.mkImageMediaOverride "nixos-tsrk-${host}.iso";
}
