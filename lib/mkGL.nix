{ pkgSet, ... }:

let
  inherit (pkgSet) pkgs;
in
config: command:

if (config.targets.genericLinux.enable) then
  "${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL ${command}"
else
  command
