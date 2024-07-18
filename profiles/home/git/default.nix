{ self, ... }:

{
  imports = with self.homeManagerModules; [
    git
  ];

  tsrk.git = {
    enable = true;
    cli.enable = true;
    delta.enable = true;
    lazygit.enable = true;
  };
}
