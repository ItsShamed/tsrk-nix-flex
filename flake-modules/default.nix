{ lib, inputs, self, ... }:

let
  importPkgs = pkgs: system: withOverlays:
    import pkgs {
      inherit system;
      config = {
        allowUnfree = true;
        android_sdk.accept_license = true;
      };
      overlays = [
      ] ++ (lib.lists.optionals withOverlays (builtins.attrValues (
        builtins.removeAttrs (self.overlays) [ "all" "default" ]
      )));
    };
in
{
  imports = [
    ./overlays.nix
    ./packages.nix
    ../lib
  ];

  perSystem = { system, ... }: {
    _module.args = {
      pkgs = importPkgs inputs.nixpkgs system true;
      pkgsUnstable = importPkgs inputs.nixpkgsUnstable system true;
    };
  };
}
