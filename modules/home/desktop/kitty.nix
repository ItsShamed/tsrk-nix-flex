{ inputs, ... }:

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
  hmLib = inputs.home-manager.lib.hm;
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

      theme = lib.mkDefault "Tokyo Night";

      shellIntegration = {
        enableBashIntegration = true;
        enableZshIntegration = true;
        enableFishIntegration = true;
      };
    };

    specialisation = {
      light.configuration = {
        programs.kitty.theme = lib.mkForce "Tokyo Night Day";
      };
      dark.configuration = {
        programs.kitty.theme = lib.mkForce "Tokyo Night Storm";
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
