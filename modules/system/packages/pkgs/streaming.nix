{
  config,
  lib,
  pkgs,
  ...
}: {
  option = {
    tsrk.packages.pkgs.streaming.enable =
      lib.options.mkEnableOption "tsrk's streaming bundle";
    tsrk.packages.pkgs.streaming.obsPluginAdditions =
      lib.options.mkEnableOption "OBS Studio plugin additions";
  };

  config = lib.mkMerge [
    (lib.mkIf config.tsrk.packages.pkgs.streaming.enable {
      environment.systemPackages = with pkgs; [obs-studio];
    })

    (lib.mkIf config.tsrk.packages.pkgs.streaming.obsPluginAdditions {
      environment.systemPackages = with pkgs.obs-studio-plugins; [
        obs-multi-rtmp
        obs-ndi
        looking-glass-obs
        obs-move-transition
        advanced-scene-switcher
        obs-pipewire-audio-capture
      ];
    })
  ];
}
