# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ inputs, ... }:

{ config, lib, pkgs, ... }:

let
  kernelVersion =
    builtins.splitVersion config.boot.kernelPackages.kernel.version;
  kernelMajor = lib.strings.toInt (builtins.elemAt kernelVersion 0);
  kernelMinor = lib.strings.toInt (builtins.elemAt kernelVersion 1);

  fixedKernelVersion = builtins.splitVersion "6.7";
  fixedKernelMajor = lib.strings.toInt (builtins.elemAt fixedKernelVersion 0);
  fixedKernelMinor = lib.strings.toInt (builtins.elemAt fixedKernelVersion 1);

  isAudioFixed = kernelMajor > fixedKernelMajor
    || (kernelMajor == 6 && kernelMinor >= fixedKernelMinor);
in {
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
    (lib.mkIf config.tsrk.sound.focusriteSupport (lib.mkMerge [
      { environment.systemPackages = with pkgs; [ alsa-scarlett-gui ]; }
      (lib.mkIf (!isAudioFixed) {
        boot.extraModprobeConfig = ''
          ### FOCUSRITE SUPPORT

          ## Scarlett Gen 2
          # 6i6
          options snd_usb_audio vid=0x1235 pid=0x8203 device_setup=1
          # 18i8
          options snd_usb_audio vid=0x1235 pid=0x8204 device_setup=1
          # 18i20
          options snd_usb_audio vid=0x1235 pid=0x8201 device_setup=1

          ## Scarlett Gen 3
          # Solo
          options snd_usb_audio vid=0x1235 pid=0x8211 device_setup=1
          # 2i2
          options snd_usb_audio vid=0x1235 pid=0x8210 device_setup=1
          # 4i4
          options snd_usb_audio vid=0x1235 pid=0x8212 device_setup=1
          # 8i6
          options snd_usb_audio vid=0x1235 pid=0x8213 device_setup=1
          # 18i8
          options snd_usb_audio vid=0x1235 pid=0x8214 device_setup=1
          # 18i20
          options snd_usb_audio vid=0x1235 pid=0x8215 device_setup=1

          ## Clarett+ 8 Pre
          options snd_usb_audio vid=0x1235 pid=0x820c device_setup=1
        '';
      })
    ]))
  ]);
}
