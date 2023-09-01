{ lib, ... }:

let
  importModule = file: 
  {
    name = lib.strings.removeSuffix ".nix" (builtins.baseNameOf file);
    value = import newFile;
  };
in
  builtins.listToAttrs (
    builtins.map importModule (
      import ./imports.nix
    )
  )
