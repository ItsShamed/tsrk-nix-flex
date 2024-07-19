{ pkgs, lib, config, self, ... }:

{
  options = {
    tsrk.rofi = {
      enable = lib.options.mkEnableOption "Rofi configuration";
    };
  };

  config = lib.mkIf config.tsrk.rofi.enable (lib.mkMerge [
    {
      programs.rofi = {
        enable = true;
        plugins = with pkgs; [
          rofi-emoji
        ];
        theme = "${pkgs.rofi-themes-collection}/simple-tokyonight.rasi";
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
    }
    (lib.mkIf config.xsession.windowManager.i3.enable (
      let
        mod = config.xsession.windowManager.i3.config.modifier;
      in
      {
        xsession.windowManager.i3.config.keybindings = lib.mkDefault {
          "${mod}+Shift+e" = "rofi -show p -modi p:'rofi-power-menu'";
        };
      }
    ))
  ]);
}
