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

      verboseEcho "Sending SIGHUP to all xsettingsd instances"
      if ! ${pkgs.killall}/bin/killall -HUP xsettingsd; then
        verboseEcho "Reloading xsettingsd systemd service"
        if ! ${config.systemd.user.systemctlPath} --user restart xsettingsd; then
          _iWarn "Failed to reload xsettingsd, themes will not be updated"
        fi
      else
        if ! ${config.systemd.user.systemctlPath} --user is-active xsettingsd; then
          warnEcho "xsettingsd is no longer active, trying to re-enable it"
          if ! ${config.systemd.user.systemctlPath} --user enable --now xsettingsd; then
            warnEcho "Failed to enable xsettingsd service, themes will not be updated"
          fi
        fi
        ${pkgs.lxappearance}/bin/lxappearance &
        ${pkgs.coreutils}/bin/sleep 1
        ${pkgs.killall}/bin/killall .lxappearance-wrapped
      fi
      systemctl --user restart xsettingsd
    '';
  };
}
