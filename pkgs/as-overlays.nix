let
  topLevelPackages = import ./all-packages.nix;

  callPackage = pkgArgs: self: super:
    let
      defaultArgs = {
        callPackage = self: super: self.callPackage;
        args = self: super: { };
      };

      pkgDecl =
        if builtins.isAttrs pkgArgs then
          (defaultArgs // pkgArgs)
        else
          defaultArgs // { path = pkgArgs; };
    in
    (pkgDecl.callPackage self super) pkgDecl.path (pkgDecl.args self super);

  pkgToOverlay = name: pkgArgs: self: super: {
    "${name}" = callPackage pkgArgs self super;
  };
in
builtins.mapAttrs pkgToOverlay topLevelPackages
