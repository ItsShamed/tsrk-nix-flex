{ self, lib, ... }:

{
  imports = with self.homeManagerModules; [
    packages
    profile-tsrk-common
    profile-tsrk-private
  ];

  tsrk = {
    picom.enable = lib.mkImageMediaOverride false;
    packages = {
      # TODO: Re-enable after bootstrap
      # games.enable = true;
      media.enable = true;
    };
    darkman = {
      feh = {
        dark = ./files/bocchi-tokyonight-storm.png;
        light = ./files/lagtrain-tokyonight-day.png;
      };
    };
    polybar = {
      wlanInterfaceName = "wlp1s0";
    };
    nvim.wakatime.enable = true;
  };
}
