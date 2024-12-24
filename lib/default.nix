{ lib, ... }@args:

rec {
  mkIfElse = predicate: positiveValue: negativeValue:
    lib.mkMerge [
      (lib.mkIf predicate positiveValue)
      (lib.mkIf (!predicate) negativeValue)
    ];

  generateUser = import ./generateUser.nix;
  generateHome = import ./generateHome.nix args;
  generateSystemHome = import ./generateSystemHome.nix args;
  generateFullUser = import ./generateFullUser.nix
    (args // { inherit generateUser generateSystemHome; });
  fromYAML = import ./fromYAML.nix args;
  mkGL = import ./mkGL.nix args;

  profileNeedsPkg = name: config: {
    assertion = config ? tsrk && config.tsrk ? packages;
    message =
      "This profile (${name}) requires the `package' module to be imported.";
  };
}
