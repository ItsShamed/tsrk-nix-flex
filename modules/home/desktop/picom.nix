{ config, pkgs, lib, ... }:

let
  baseConfig = lib.mkIf config.tsrk.i3.enable {
    services.picom = {
      # FIXME: find better alternative, this fork will be deleted anytime soon
      package = pkgs.picom-allusive;
      enable = true;
      fade = true;
      extraArgs = [ "--no-use-damage" ];
      backend = "xr_glx_hybrid";
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
      settings = {
        animation-open-exclude = [
          "class_g = 'i3lock'"
        ];
        animation-unmap-exclude = [
          "class_g = 'i3lock'"
        ];
        animation-dampening = 5;
        animation-stiffnes = 50;
        animation-window-mass = 0.10;
        animation-for-unmap-window = "slide-down";
        wintypes = {
          notification = {
            animation = "slide-left";
            animation-unmap = "slide-right";
          };
          dropdown_menu = {
            animation = "slide-down";
            animation-unmap = "slide-up";
          };
          menu = {
            animation = "slide-up";
            animation-unmap = "slide-down";
          };
          tooltip = {
            animation = "slide-up";
            animation-unmap = "slide-down";
          };
          popup_menu = {
            animation = "zoom";
            animation-unmap = "zoom";
          };
          dialog = {
            animation = "zoom";
            animation-unmap = "zoom";
          };
        };
      };
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
