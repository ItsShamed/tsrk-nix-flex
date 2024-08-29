{ self, ... }:

{
  flake.nixosModules = (self.lib.mkBulkImportModule { path = ../modules/system/imports.nix; })
    // (self.lib.mkBulkImportModule { path = ../profiles/system/imports.nix; prefix = "profile"; generateAll = false; })
    // { default = self.nixosModules.all; };

  flake.homeManagerModules = (self.lib.mkBulkImportModule { path = ../modules/home/imports.nix; localModules = self.homeManagerModules; })
    // (self.lib.mkBulkImportModule { path = ../profiles/system/imports.nix; prefix = "profile"; generateAll = false; localModules = self.homeManagerModules; })
    // { default = self.homeManagerModules.all; };

  flake.nixvimModules.default = import ./modules/nvim;

  perSystem = { inputs', pkgs, ... }: {
    packages = {
      nvim-cirno = inputs'.nixvim.legacyPackages.makeNixvimWithModule {
        module = self.nixvimModules.default;
        inherit pkgs;
      };
    };
  };
}
