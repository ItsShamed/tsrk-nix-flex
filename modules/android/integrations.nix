{ config, lib, ... }:

let
  cfg = config.tsrk.integrations;
in
{
  options = {
    tsrk.integrations = {
      enable = lib.options.mkEnableOption "Android Integrations (Termux)";
    };
  };

  config = lib.mkIf cfg.enable {
    android-integration = {
      am.enable = lib.mkDefault true;
      termux-open.enable = lib.mkDefault true;
      termux-open-url.enable = lib.mkDefault true;
      termux-reload-settings.enable = lib.mkDefault true;
      termux-setup-storage.enable = lib.mkDefault true;
      termux-wake-lock.enable = lib.mkDefault true;
      termux-wake-unlock.enable = lib.mkDefault true;
      xdg-open.enable = lib.mkDefault true;
    };
  };
}
