{ self, ... }:

{
  imports = [
    self.homeManagerModules.bat
    self.homeManagerModules.nvim
  ];
}
