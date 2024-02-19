{ self, ... }:

{
  imports = [
    self.homeManagerModules.bat
    self.homeManagerModules.nvim
  ];

  home.file."tsrk-nix-flex".source = "${self}";
}
