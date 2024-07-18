{ self, ... }:

{
  imports = with self.homeManagerModules; [
    i3
    kitty
    polybar
  ];

  config = {
    tsrk = {
      i3 = {
        enable = true;
        useLogind = true;
      };
      kitty.enable = true;
      polybar.enable = true;
    };
  };
}
