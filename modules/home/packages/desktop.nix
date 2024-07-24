{ pkgs, lib, config, ... }:

{
  options = {
    tsrk.packages.desktop = {
      enable = lib.options.mkEnableOption "tsrk's desktop package bundle";
    };
  };

  config = lib.mkIf config.tsrk.packages.desktop.enable {
    home.packages = with pkgs; [
      # Discord replacement
      vesktop
      armcord

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

      # The best password manager (real)
      bitwarden
      spotify
    ];
  };
}
