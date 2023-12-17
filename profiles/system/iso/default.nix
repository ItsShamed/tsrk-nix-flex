{ host, lib, ... }:

{
  isoImage.isoName = lib.mkImageMediaOverride "nixos-tsrk-${host}.iso";
}
