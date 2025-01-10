# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ inputs, ... }:

{ config, lib, pkgs, ... }:

{
  imports = [ inputs.nix-gaming.nixosModules.pipewireLowLatency ];
  options = {
    tsrk.sound = {
      enable = lib.options.mkEnableOption
        "hearing things (yes it's a feature you have the choice to not enable)";
      bufferSize = lib.options.mkOption {
        type = lib.types.int;
        description =
          "The buffer size for Pipewire to use (in samples). This will determinate the latency";
        default =
          128; # This is a pretty sane default imo. Can be lower for higher-end hardware.
        example = 64;
      };

      sampleRate = lib.options.mkOption {
        type = lib.types.int;
        description = "The sample rate of Pipewire.";
        default = 48000;
        example = 44100; # Can be used when performing live.
      };

      focusriteSupport =
        lib.options.mkEnableOption "Focusrite audio interfaces support";
    };
  };

  config = lib.mkIf config.tsrk.sound.enable (lib.mkMerge [
    {
      warnings = [''
        This module (audio.nix) enables a module from fufexan/nix-gaming, which is
        known to cause issues with nixos-install.
      ''];

      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;

        lowLatency = {
          enable = true;
          quantum = config.tsrk.sound.bufferSize;
          rate = config.tsrk.sound.sampleRate;
        };
      };

      # 2024-12-01: sound.mediaKeys has been removed in 24.11
      # TODO: find how much effect this had in 24.05 and how to cope around it
      # sound.mediaKeys.enable = lib.mkDefault true;

      security.rtkit.enable = true;

      environment.systemPackages = with pkgs; [
        pavucontrol
        pa_applet
        paprefs
        easyeffects
      ];
    }
    (lib.mkIf config.tsrk.sound.focusriteSupport {
      environment.systemPackages = with pkgs; [ alsa-scarlett-gui ];
    })
  ]);
}
