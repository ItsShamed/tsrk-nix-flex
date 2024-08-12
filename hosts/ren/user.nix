{ self, lib, ... }:

{
  imports = with self.homeManagerModules; [
    packages
    profile-tsrk-common
    profile-tsrk-private
  ];

  tsrk = {
    i3.lockerBackground = ../../modules/home/desktop/files/bg-no-logo.png;
    picom.enable = lib.mkImageMediaOverride false;
    packages = {
      games.enable = true;
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
      backlightCard = "amdgpu_bl1";
    };
    nvim.wakatime.enable = true;
  };
}
