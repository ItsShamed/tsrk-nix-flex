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
    home.pointerCursor = {
      gtk.enable = lib.mkDefault true;
      x11.enable = lib.mkDefault true;
      package = pkgs.apple-cursor;
      name = "macOS-BigSur";
    };

    services.xsettingsd = {
      enable = true;
      settings = {
        "Xft/Antialias" = 1;
        "Xft/HintStyle" = "hintfull";
        "Xft/Hinting" = 1;
        "Xft/RGBA" = "rgb";
        "Gtk/CursorThemeName" = "macOS-BigSur";
        "Gtk/CursorThemeSize" = 32;
      };
    };

    gtk = {
      enable = lib.mkDefault true;
      theme = {
        package = lib.mkDefault pkgs.vimix-gtk-themes;
        name = lib.mkDefault "vimix-dark-doder";
      };
    };

    specialisation = {
      light.configuration = {
        services.xsettingsd.settings."Net/ThemeName" = "vimix-light-doder";
        gtk.theme.name = "vimix-light-doder";
      };
      dark.configuration = {
        services.xsettingsd.settings."Net/ThemeName" = "vimix-dark-doder";
        gtk.theme.name = "vimix-dark-doder";
      };
    };

    home.activation.xsettingsd-reload = hmLib.dag.entryAfter [ "reloadSystemd" ] ''
      _i "Reloading xsettingsd"

      ${config.systemd.user.systemctlPath} --user restart xsettingsd
      ${lib.meta.getExe pkgs.lxappearance}&
      sleep 2
      ${lib.meta.getExe pkgs.killall} .lxappearance-wrapped
    '';
  };
}
