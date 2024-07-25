{
  ### MISC
  tokyonight-extras = ./misc/tokyonight-extras;

  ### THEMES
  sddm-slice-theme = {
    path = ./data/themes/sddm-slice-theme;
    callPackage = self: super: super.libsForQt5.callPackage;
  };
  hyperfluent-grub-theme = ./data/themes/hyperfluent-grub-theme;

  rofi-themes-collection = ./data/themes/rofi-themes-collection;
}
