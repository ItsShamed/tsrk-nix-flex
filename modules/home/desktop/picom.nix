{ config, pkgs, lib, ... }:

{
  config = lib.mkIf config.tsrk.i3.enable {
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
