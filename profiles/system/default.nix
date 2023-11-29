{ lib, ... }:
let
  importModule = file: {
    name = "profile-" + lib.strings.removeSuffix ".nix" (builtins.baseNameOf file);
    value = import file;
  };
in
builtins.listToAttrs (builtins.map importModule (import ./imports.nix))
