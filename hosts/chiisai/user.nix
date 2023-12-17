{ self, ... }:

{
  imports = [
    self.homeManagerModules.i3
    self.homeManagerModules.polybar
    self.homeManagerModules.kitty
    self.homeManagerModules.packages
    self.homeManagerModules.dunst
    self.homeManagerModules.git
    self.homeManagerModules.zsh
    self.homeManagerModules.starship
    self.homeManagerModules.bat
    self.homeManagerModules.nvim
  ];
  tsrk.i3.enable = true;
}
