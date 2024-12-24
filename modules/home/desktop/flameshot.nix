{ lib, config, ... }:

{
  options = { tsrk.flameshot.enable = lib.options.mkEnableOption "flameshot"; };

  config = lib.mkIf config.tsrk.flameshot.enable {
    services.flameshot = {
      enable = lib.mkDefault true;
      settings = { General.useJpgForClipboard = true; };
    };
  };
}
