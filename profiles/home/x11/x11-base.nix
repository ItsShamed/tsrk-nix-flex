{ self, ... }:

{
  imports = with self.homeManagerModules; [
    i3
    kitty
    polybar
  ];

  tsrk = {
    i3 = {
      enable = true;
      useLogind = true;
    };
  };
  kitty.enable = true;
  polybar.enable = true;
}
