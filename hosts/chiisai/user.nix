{ self, config, ... }:

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
    self.homeManagerModules.thunderbird
    config.age.secrets.epitaModule.path
  ];
  age.secrets.epitaModule.file = ./epita.nix.age;
  tsrk.i3.enable = true;
}
