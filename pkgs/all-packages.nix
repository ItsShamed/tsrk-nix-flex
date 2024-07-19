{
  ### MISC
  tokyonight-extras = ./misc/tokyonight-extras;

  ### THEMES
  sddm-slice-theme = {
    path = ./data/themes/sddm-slice-theme;
    callPackage = self: super: self.libsForQt5.callPackage;
  };

  rofi-themes-collection = ./data/themes/rofi-themes-collection;
}
