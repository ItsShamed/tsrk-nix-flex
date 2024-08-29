{ mkImport, ... }:

builtins.map mkImport [
  ./git
  ./shell
  ./x11
  ./x11/x11-base.nix
  ./tsrk-common
  ./tsrk-common/tsrk-private.nix
]
