let
  topLevelPackages = import ./all-packages.nix;

  mkCallPackage = pkgDecl: pkgs:
    (pkgDecl.callPackage pkgs) pkgDecl.path (pkgDecl.args pkgs);

  pkgToOverlay = name: pkgArgs: self: super:
    let
      defaultArgs = {
        callPackage = pkgs: pkgs.callPackage;
        args = pkgs: { };
      };

      pkgDecl =
        if builtins.isAttrs pkgArgs then
          (defaultArgs // pkgArgs)
        else
          defaultArgs // { path = pkgArgs; };

      overrideDecl = args: pkgDecl // { args = _: args; };
    in
    {
      "${name}" = (mkCallPackage pkgDecl super) // {
        override = args: mkCallPackage (overrideDecl args) super;
      };
    };
in
builtins.mapAttrs pkgToOverlay topLevelPackages
