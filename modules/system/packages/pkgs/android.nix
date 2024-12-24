# Copyright (c) 2024 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ config, lib, pkgs, ... }:

let
  cfg = config.tsrk.packages.pkgs.android;
  androidComposition = pkgs.androidenv.composeAndroidPackages {
    cmdLineToolsVersion = "8.0";
    toolsVersion = "26.1.1";
    platformToolsVersion = "33.0.3";
    buildToolsVersions = [ "33.0.3" ];
    includeEmulator = false;
    emulatorVersion = "30.3.4";
    includeSources = false;
    includeSystemImages = true;
    systemImageTypes = [ "google_apis_playstore" "default" ];
    abiVersions = [ "armeabi-v7a" "arm64-v8a" ];
    cmakeVersions = [ "3.10.2" ];
    includeNDK = true;
    ndkVersions = [ "22.0.7026061" ];
    useGoogleAPIs = true;
    includeExtras = [ "extras;google;gcm" ];
  };
in {
  options = {
    tsrk.packages.pkgs.android = {
      enable = lib.options.mkEnableOption "tsrk's Android bundle";
      ide = {
        enable = (lib.options.mkEnableOption "Android Studio (IDE)") // {
          default = true;
        };
        package = lib.options.mkPackageOption pkgs "Android Studio" {
          default = [ "android-studio" ];
          example = "pkgs.androidStudioPackages.beta";
        };
      };
      androidComposition = lib.options.mkOption {
        description = "The Android SDK composition";
        type = lib.types.attrs;
        default = androidComposition;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    tsrk.packages.pkgs.java.enable = lib.mkDefault true;
    programs.adb.enable = true;

    environment.variables = {
      ANDROID_SDK_ROOT =
        "${cfg.androidComposition.androidsdk}/libexec/android-sdk";
    };

    environment.systemPackages = with pkgs;
      [
        apktool
        android-file-transfer
        flutter
        scrcpy
        cfg.androidComposition.androidsdk
        cfg.androidComposition.platform-tools
      ] ++ lib.lists.optional cfg.ide.enable cfg.ide.package;
  };
}
