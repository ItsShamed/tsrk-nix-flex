{ config, pkgs, lib, ... }:

let
  baseConfig = lib.mkIf config.tsrk.i3.enable {
    services.picom = {
      # FIXME: find better alternative, this fork will be deleted anytime soon
      enable = true;
      fade = true;
      extraArgs = [ "--no-use-damage" ];
      backend = "glx";
      fadeDelta = 5;
      fadeSteps = [ 0.075 0.030 ];
      opacityRules = [
        "100:class_g = 'kitty' && focused"
        "75:class_g = 'kitty' && !focused"
      ];
      shadow = true;
      shadowExclude = [
        "class_g = 'Dunst'"
      ];
    };
  };

  picomCfg = config.services.picom;

  compatConfig = lib.mkIf config.targets.genericLinux.enable {
    systemd.user.services.picom.Service.ExecStart = lib.mkForce (
        lib.strings.concatStringsSep " " ([
          config.tsrk.compatWrapper
          "${lib.meta.getExe picomCfg.package}"
          "--config ${config.xdg.configFile."picom/picom.conf".source}"
        ] ++ picomCfg.extraArgs)
    );
  };
in
{
  config = lib.mkMerge [
    baseConfig
    compatConfig
  ];
}
