{ lib, withSystem, ... } @ args:

{
  flake.lib = rec {
    mkIfElse = predicate: positiveValue: negativeValue: lib.mkMerge [
      (lib.mkIf predicate positiveValue)
      (lib.mkIf (!predicate) negativeValue)
    ];

    generateUser = import ./generateUser.nix;
    generateHome = import ./generateHome.nix args;
    generateSystemHome = import ./generateSystemHome.nix args;
    generateFullUser = import ./generateFullUser.nix (args // { inherit generateUser generateSystemHome; });
    fromYAML = withSystem "x86_64-linux" (import ./fromYAML.nix);
    mkGL = import ./mkGL.nix { inherit withSystem; };
    mkBulkImportModule = import ./mkBulkImportModule.nix;

    profileNeedsPkg = name: config: {
      assertion = config ? tsrk && config.tsrk ? packages;
      message = "This profile (${name}) requires the `package' module to be imported.";
    };
  };
}
