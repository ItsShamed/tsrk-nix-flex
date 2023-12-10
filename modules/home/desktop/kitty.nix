{ config, pkgs, lib, osConfig ? {}, ... }:

let
  fonts = pkgs.nerdfonts.override {
    fonts = [
      "Iosevka"
        "IosevkaTerm"
        "JetBrainsMono"
        "Meslo"
        "FiraCode"
    ];
  };
  systemReady = if osConfig ? tsrk.packages.pkgs.desktop.enable then
    osConfig.tsrk.packages.pkgs.desktop.enable else true;
in
{
  config = lib.mkIf systemReady {
    programs.kitty = {
      enable = true;
      font = lib.mkDefault {
        package = fonts;
        name = "Iosevka Nerd Font";
      };

      theme = lib.mkDefault "Tokyo Night";

      shellIntegration.enableZshIntegration = true;
    };
  };
}
