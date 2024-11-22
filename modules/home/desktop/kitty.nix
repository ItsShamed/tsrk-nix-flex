{ config, pkgs, lib, hmLib, ... }:

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
    tsrk.kitty.enable = lib.options.mkEnableOption "kitty terminal emulator";
  };

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      font = lib.mkDefault {
        package = fonts;
        name = "Iosevka Nerd Font";
      };

      themeFile = lib.mkDefault "tokyo_night_moon";

      shellIntegration = {
        enableBashIntegration = true;
        enableZshIntegration = true;
        enableFishIntegration = true;
      };
    };

    specialisation = {
      light.configuration = {
        programs.kitty.themeFile = lib.mkForce "tokyo_night_day";
      };
      dark.configuration = {
        programs.kitty.themeFile = lib.mkForce "tokyo_night_storm";
      };
    };

    home.activation.kitty-reload = hmLib.dag.entryAfter [ "reloadSystemd" ] ''
      _i "Reloading kitty"
      if ! ${pkgs.killall}/bin/killall -USR1 .kitty-wrapped; then
        _iWarn "Failed to reload kitty, theme will not be updated"
      fi
    '';
  };

}
