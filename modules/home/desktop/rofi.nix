{ withSystem, self, ... }:

{ pkgs, lib, config, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  options = {
    tsrk.rofi = {
      enable = lib.options.mkEnableOption "Rofi configuration";
    };
  };

  config = lib.mkIf config.tsrk.rofi.enable {
    programs.rofi = {
      enable = true;
      plugins = with pkgs; [
        rofi-emoji
      ];
      theme = withSystem system ({ self', ... }: "${self'.packages.rofi-themes-collection}/simple-tokyonight.rasi");
      terminal = (self.lib.mkIfElse (config.programs.kitty.enable)
        "kitty"
        "${pkgs.alacritty}/bin/alacritty"
      );
      extraConfig = {
        modi = "drun,run";
        font = "Iosevka Nerd Font 12";
      };
    };

    home.packages = with pkgs; [
      rofi-power-menu
    ];
  };
}
