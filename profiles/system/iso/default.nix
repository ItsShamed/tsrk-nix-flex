{ config, lib, ... }:

{
  isoImage.isoName = lib.mkImageMediaOverride "nixos-${config.networking.hostName}.iso";
}
