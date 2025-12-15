# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.tsrk.packages.pkgs.android;
  androidComposition = pkgs.androidenv.composeAndroidPackages {
    includeEmulator = false;
    includeSources = false;
    includeSystemImages = true;
    systemImageTypes = [
      "google_apis_playstore"
      "default"
    ];
    abiVersions = [
      "armeabi-v7a"
      "arm64-v8a"
    ];
    includeNDK = true;
    useGoogleAPIs = true;
    includeExtras = [
      "extras;google;gcm"
      "extras;google;auto"
    ];
  };
in
{
  options = {
    tsrk.packages.pkgs.android = {
      enable = lib.options.mkEnableOption "tsrk's Android bundle";
      ide = {
        enable = lib.options.mkEnableOption "Android Studio (IDE)";
        package = lib.options.mkPackageOption pkgs "Android Studio" {
          default = [ "android-studio" ];
          example = "pkgs.androidStudioPackages.beta";
        };
      };
      androidComposition = lib.options.mkOption {
        description = "The Android SDK composition";
        type = lib.types.attrs;
        default = androidComposition;
        defaultText = ''
          pkgs.androidenv.composeAndroidPackages {
            includeEmulator = false;
            includeSources = false;
            includeSystemImages = true;
            systemImageTypes = [ "google_apis_playstore" "default" ];
            abiVersions = [ "armeabi-v7a" "arm64-v8a" ];
            includeNDK = true;
            useGoogleAPIs = true;
            includeExtras = [ "extras;google;gcm;auto" ];
          };
        '';
      };
      flutter.enable = lib.options.mkEnableOption "Flutter SDK";
    };
  };

  config = lib.mkIf cfg.enable {
    tsrk.packages.pkgs.java.enable = lib.mkDefault true;
    programs.adb.enable = true;
    nixpkgs.config.android_sdk.accept_license = true;

    environment.variables = {
      ANDROID_SDK_ROOT = "${cfg.androidComposition.androidsdk}/libexec/android-sdk";
    };

    environment.systemPackages =
      with pkgs;
      [
        apktool
        android-file-transfer
        scrcpy
        cfg.androidComposition.androidsdk
        cfg.androidComposition.platform-tools
      ]
      ++ lib.lists.optional cfg.flutter.enable flutter
      ++ lib.lists.optional cfg.ide.enable cfg.ide.package;
  };
}
