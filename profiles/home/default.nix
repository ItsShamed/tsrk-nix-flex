{ self, ... }:

{
  imports = [
    (self.lib.mkBulkImportModule {
      prefix = "profile";
      namespace = "homeManagerModules";
      path = ./imports.nix;
      generateAll = false;
    })
  ];
}
