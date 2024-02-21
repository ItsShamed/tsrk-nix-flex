{ config, pkgs, lib, ... }:

let
  xsettingsd-light = pkgs.writeShellScriptBin "xsettingsd-light" ''
    ${pkgs.gnused}/bin/sed --in-place --follow-symlinks 's/-dark/-light/' "${config.home.homeDirectory}/.xsettingsd"
    ${pkgs.gnused}/bin/sed --in-place --follow-symlinks 's/-Dark/-Light/' "${config.home.homeDirectory}/.xsettingsd"
    ${pkgs.killall}/bin/killall -HUP xsettingsd || true
    ${pkgs.lxappearance}/bin/lxappearance &
    ${pkgs.coreutils}/bin/sleep 1
    ${pkgs.killall}/bin/killall .lxappearance-wrapped
  '';
  xsettingsd-dark = pkgs.writeShellScriptBin "xsettingsd-dark" ''
    ${pkgs.gnused}/bin/sed --in-place --follow-symlinks 's/-light/-dark/' "${config.home.homeDirectory}/.xsettingsd"
    ${pkgs.gnused}/bin/sed --in-place --follow-symlinks 's/-Light/-Dark/' "${config.home.homeDirectory}/.xsettingsd"
    ${pkgs.killall}/bin/killall -HUP xsettingsd || true
    ${pkgs.lxappearance}/bin/lxappearance &
    ${pkgs.coreutils}/bin/sleep 1
    ${pkgs.killall}/bin/killall .lxappearance-wrapped
  '';

  baseConfig = {
    services.darkman = {
      enable = lib.mkDefault true;
      settings = {
        usegeoclue = true;
        lng = 48.87951;
        lat = 2.28513;
      };
      lightModeScripts = {
        dunst-notif = ''
          ${pkgs.dunst}/bin/dunstify -a "Darkman - Theme Switching" "Shine bright like a diamond 🌅💎💅"
        '';
      };
      darkModeScripts = {
        dunst-notif = ''
          ${pkgs.dunst}/bin/dunstify -a "Darkman - Theme Switching" "Let tonight's dream begin 🌙✨"
        '';
      };
    };
  };
  xsettingsdLoaded = config.tsrk ? xsettingsd.enable && config.tsrk.xsettingsd.enable;
  xsettingsdConfig = {
    services.darkman = {
      lightModeScripts.xsettingsd = ''
          ${pkgs.bash}/bin/bash ${xsettingsd-light}/bin/xsettingsd-light
        '';
      darkModeScripts.xsettingsd = ''
          ${pkgs.bash}/bin/bash ${xsettingsd-dark}/bin/xsettingsd-dark
        '';
    };
  };
in
{
  options = {
    tsrk.darkman.enable = lib.options.mkEnableOption "darkman";
  };

  config = lib.mkIf config.tsrk.darkman.enable (lib.mkMerge [
      baseConfig
      (lib.mkIf xsettingsdLoaded xsettingsdConfig)
  ]);
}
