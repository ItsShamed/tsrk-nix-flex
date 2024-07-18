{ pkgSet, mkIfElse, ... }:

let
  inherit (pkgSet) pkgs;
in
config: command:

mkIfElse (config.targets.genericLinux.enable)
  "${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL ${command}"
  command
