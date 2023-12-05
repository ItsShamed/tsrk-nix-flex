{ config, lib, pkgs, ... }:

let
  cfg = config.tsrk.packages.pkgs.android;
in
{
  options = {
    tsrk.packages.pkgs.android = {
      enable = lib.options.mkEnableOption "tsrk's Android bundle";
      ide = {
        enable = (lib.options.mkEnableOption "Android Studio (IDE)")
          // { default = true; };
        package = lib.options.mkPackageOption pkgs "Android Studio" {
          default = [ "android-studio" ];
          example = "pkgs.androidStudioPackages.beta";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    tsrk.packages.pkgs.java.enable = lib.mkDefault true;
    programs.adb.enable = true;

    environment.systemPackages =
      lib.lists.optional cfg.ide.enable cfg.ide.package;
  };
}
