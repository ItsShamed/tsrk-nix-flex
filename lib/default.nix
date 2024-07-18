{ lib, ... } @ args:

rec {
  mkIfElse = predicate: positiveValue: negativeValue: lib.mkMerge [
    (lib.mkIf predicate positiveValue)
    (lib.mkIf (!predicate) negativeValue)
  ];

  generateUser = import ./generateUser.nix;
  generateHome = import ./generateHome.nix args;
  generateSystemHome = import ./generateSystemHome.nix args;
  generateFullUser = import ./generateFullUser.nix (args // { inherit generateUser generateSystemHome; });
  fromYAML = import ./fromYAML.nix args;
}
