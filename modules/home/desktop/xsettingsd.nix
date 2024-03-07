{ config, pkgs, lib, hmLib, ... }:

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
      };
    };

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
    if ! ${pkgs.killall}/bin/killall -HUP xsettingsd; then
      _iWarn "Failed to reload xsettingsd, themes will not be updated"
    else
      ${pkgs.lxappearance}/bin/lxappearance &
      ${pkgs.coreutils}/bin/sleep 1
      ${pkgs.killall}/bin/killall .lxappearance-wrapped
    fi
    '';
  };
}
