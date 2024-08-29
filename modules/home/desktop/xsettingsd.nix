{ withSystem, inputs, ... }:

{ config, lib, pkgs, ... }:

let
  cfg = config.tsrk.xsettingsd;
  system = pkgs.stdenv.hostPlatform.system;
  hmLib = inputs.home-manager.lib.hm;
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
        "Xcursor/size" = 32;
      };
    };

    home.packages = withSystem system ({ self', ... }: with self'.packages; [
      tokyonight-gtk-theme
      (tokyonight-gtk-theme.override {
        tweaks = [ "storm" ];
      })
    ]);

    specialisation = {
      light.configuration = {
        services.xsettingsd.settings."Net/ThemeName" = "TokyoNight-Light";
      };
      dark.configuration = {
        services.xsettingsd.settings."Net/ThemeName" = "TokyoNight-Dark-Storm";
      };
    };

    home.activation.xsettingsd-reload = hmLib.dag.entryAfter [ "reloadSystemd" ] ''
      _i "Reloading xsettingsd"

      ${config.systemd.user.systemctlPath} --user restart xsettingsd
      ${lib.meta.getExe pkgs.lxappearance}&
      sleep 1
      ${lib.meta.getExe pkgs.killall} .lxappearance-wrapped
    '';
  };
}
