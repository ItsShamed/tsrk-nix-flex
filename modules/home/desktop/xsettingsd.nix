{ config, lib, hmLib, pkgs, ... }:

let
  cfg = config.tsrk.xsettingsd;
in
{
  options = {
    tsrk.xsettingsd = {
      enable = lib.options.mkEnableOption "xsettingsd";
    };
  };

  config = lib.mkIf cfg.enable {
    services.xsettingsd = {
      enable = true;
      settings = {
        "Xft/Antialias" = 1;
        "Xft/HintStyle" = "hintfull";
        "Xft/Hinting" = 1;
        "Xft/RGBA" = "rgb";
        "Net/CursorThemeName" = "macOS-BigSur";
      };
    };

    home.packages = with pkgs; [
      apple-cursor
      vimix-gtk-themes
    ];

    specialisation = {
      light.configuration = {
        services.xsettingsd.settings."Net/ThemeName" = "vimix-light-doder";
      };
      dark.configuration = {
        services.xsettingsd.settings."Net/ThemeName" = "vimix-dark-doder";
      };
    };

    home.activation.xsettingsd-reload = hmLib.dag.entryAfter [ "reloadSystemd" ] ''
      _i "Reloading xsettingsd"

      ${config.systemd.user.systemctlPath} --user restart xsettingsd
    '';
  };
}
