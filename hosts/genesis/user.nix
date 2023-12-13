{ self, ... }:

{
  imports = [
    self.homeManagerModules.i3
    self.homeManagerModules.kitty
    self.homeManagerModules.dunst
    self.homeManagerModules.git
    self.homeManagerModules.bat
    self.homeManagerModules.nvim
  ];
  tsrk.i3.enable = true;
}
