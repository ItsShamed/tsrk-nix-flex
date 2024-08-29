{ self, ... }:

{
  imports = [
    (self.lib.mkBulkImportModule {
      prefix = "profile";
      path = ./imports.nix;
      generateAll = false;
    })
  ];
}
