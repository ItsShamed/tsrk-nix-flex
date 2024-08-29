{
  ### AUDIO
  spotify-adblock = ./applications/audio/spotify-adblock;

  ### DEVELOPMENT
  realm-studio = ./development/misc/realm-studio;

  ### GAMES
  paladium-launcher = ./games/paladium-launcher;

  rewind = ./games/rewind;

  ### MISC
  polybar-mpris = ./applications/misc/polybar-mpris;
  tokyonight-extras = ./misc/tokyonight-extras;

  ### THEMES
  sddm-slice-theme = {
    path = ./data/themes/sddm-slice-theme;
    callPackage = pkgs: pkgs.libsForQt5.callPackage;
  };
  hyperfluent-grub-theme = ./data/themes/hyperfluent-grub-theme;

  rofi-themes-collection = ./data/themes/rofi-themes-collection;

  tokyonight-gtk-theme = ./data/themes/tokyonight-gtk-theme;
}
