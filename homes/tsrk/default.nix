{ self, inputs, lib, ... }:

{
  imports = with self.homeManagerModules; [
    packages
    profile-tsrk-common
    profile-tsrk-private
    ./extra-packages.nix
    (inputs.spotify-notifyx.homeManagerModules.default inputs.spotify-notifyx)
  ];

  tsrk = {
    picom.enable = lib.mkImageMediaOverride false;
    i3.epitaRestrictions = true;
    darkman = {
      feh = {
        dark = ./files/bocchi-tokyonight-storm.png;
        light = ./files/lagtrain-tokyonight-day.png;
      };
    };
    polybar = {
      ethInterfaceName = "eno1";
      wlanInterfaceName = "wlan0";
    };
    nvim.wakatime.enable = true;
  };
  targets.genericLinux.enable = true;
}
