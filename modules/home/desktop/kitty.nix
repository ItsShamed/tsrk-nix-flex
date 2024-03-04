{ config, pkgs, lib, ... }:

let
  fonts = pkgs.nerdfonts.override {
    fonts = [
      "Iosevka"
      "IosevkaTerm"
      "JetBrainsMono"
      "Meslo"
    ];
  };
  cfg = config.tsrk.kitty;
in
{
  options = {
    tsrk.kitty.enable = lib.options.mkEnableOptions "kitty terminal emulator";
  };
  config = lib.mkIf cfg.enable {
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
