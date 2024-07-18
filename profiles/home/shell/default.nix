{ self, lib, ... }:

{
  imports = with self.homeManagerModules; [
    nvim
    shell
  ];

  config = {
    tsrk.shell = {
      bash.enable = lib.mkDefault true;
      bat.enable = true;
      enableViKeybinds = true;
      fastfetch.enable = true;
      lsd.enable = true;
      starship.enable = true;
      zoxide.enable = true;
      zsh.enable = lib.mkDefault true;
    };
  };
}
