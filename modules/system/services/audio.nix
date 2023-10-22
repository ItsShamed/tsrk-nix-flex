{ config, lib, inputs, pkgs, ... }:

{
  options = {
    tsrk.sound = {
      enable = lib.options.mkEnableOption "hearing things (yes it's a feature you have the choice to not enable)";
      bufferSize = lib.options.mkOption {
        type = lib.types.int;
        description = "The buffer size for Pipewire to use (in samples). This will determinate the latency";
        default = 128; # This is a pretty sane default imo. Can be lower for higher-end hardware.
        example = 64;
      };

      sampleRate = lib.options.mkOption {
        type = lib.types.int;
        description = "The sample rate of Pipewire.";
        default = 48000;
        example = 44100; # Can be used when performing live.
      };
    };
  };

  config = lib.mkIf config.tsrk.sound {
    imports = [ inputs.nix-gaming.nixosModules.pipewireLowLatency ];
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32bit = true;
      pulse.enable = true;

      lowLatency = {
        enable = true;
        quantum = config.tsrk.sound.bufferSize;
        rate = config.tsrk.sound.sampleRate;
      };
    };

    security.rtkit.enable = true;

    environment.systemPackages = with pkgs; [
      pavucontrol
      pa_applet
      paprefs
    ];
  };
}
