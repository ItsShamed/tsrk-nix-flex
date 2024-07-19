{ self, lib, config, ... }:

{
  imports = with self.homeManagerModules; [
    nvim
    shell
  ];

  config = {
    assertions = [ (self.lib.profileNeedsPkg "Shell" config) ];
    tsrk.packages.core.enable = lib.mkDefault true;
    tsrk.shell = {
      bash.enable = lib.mkDefault true;
      bat.enable = lib.mkDefault true;
      enableViKeybinds = lib.mkDefault true;
      fastfetch.enable = lib.mkDefault true;
      lsd.enable = lib.mkDefault true;
      starship.enable = lib.mkDefault true;
      zoxide.enable = lib.mkDefault true;
      zsh.enable = lib.mkDefault true;
    };
  };
}
