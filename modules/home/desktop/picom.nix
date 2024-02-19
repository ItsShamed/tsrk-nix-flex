{ config, pkgs, lib, osConfig ? { }, ... }:

let
  systemReady =
    if osConfig ? tsrk.i3.enable then
      osConfig.tsrk.i3.enable else true;
in
{
  config = lib.mkIf (systemReady && config.tsrk.i3.enable) {
    services.picom = {
      enable = true;
      fade = true;
      fadeDelta = 5;
      fadeSteps = [ 0.075 0.030 ];
      opacityRules = [
        "100:class_g = 'kitty' && focused"
        "75:class_g = 'kitty' && !focused"
      ];
    };
  };
}
