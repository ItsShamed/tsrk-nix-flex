{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Discord replacement
    vesktop

    # Fonts
    (nerdfonts.override {
      fonts = [
        "Iosevka"
        "IosevkaTerm"
        "JetBrainsMono"
        "Meslo"
      ];
    })
    iosevka
    meslo-lgs-nf

    rofi

    # The best password manager (real)
    bitwarden
    spotify

    vimix-gtk-themes
  ];
}
