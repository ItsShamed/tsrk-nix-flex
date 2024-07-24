{ self, ... }:

{
  imports = with self.homeManagerModules; [
    packages
    profile-tsrk-common
    profile-tsrk-private
  ];

  tsrk = {
    packages = {
      games.enable = true;
      more-gaming.enable = true;
      media.enable = true;
    };
    nvim.wakatime.enable = true;
    polybar = {
      ethInterfaceName = "enp16s0";
      wlanInterfaceName = "wlp15s0";
    };
  };
}
