{ self, ... }:

{
  imports = with self.homeManagerModules; [
    git
  ];

  config = {
    tsrk.git = {
      enable = true;
      cli.enable = true;
      delta.enable = true;
      lazygit.enable = true;
    };
  };
}
