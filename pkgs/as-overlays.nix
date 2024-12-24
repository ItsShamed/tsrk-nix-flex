let
  topLevelPackages = import ./all-packages.nix;

  callPackage = pkgDecl: self: super:
    (pkgDecl.callPackage self super) pkgDecl.path (pkgDecl.args self super);

  pkgToOverlay = name: pkgArgs: self: super:
    let
      defaultArgs = {
        callPackage = self: super: self.callPackage;
        args = self: super: { };
      };

      pkgDecl = if builtins.isAttrs pkgArgs then
        (defaultArgs // pkgArgs)
      else
        defaultArgs // { path = pkgArgs; };

      overrideDecl = args: pkgDecl // { inherit args; };
    in {
      "${name}" = (callPackage pkgDecl self super) // {
        override = args: callPackage (overrideDecl args) self super;
      };
    };
in builtins.mapAttrs pkgToOverlay topLevelPackages
