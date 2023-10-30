{ lib, ... } @ args:

{
  mkIfElse = predicate: positiveValue: negativeValue: lib.mkMerge [
    (lib.mkIf predicate positiveValue)
    (lib.mkIf (!predicate) negativeValue)
  ];

  generateUser = import ./generateUser.nix;
  generateHome = import ./generateHome.nix args;
}
