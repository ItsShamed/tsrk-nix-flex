{ config, lib, pkgs, ... }:

let
  cfg = config.tsrk.packages.pkgs.csharp;
in
{
  options = {
    tsrk.packages.pkgs.csharp = {
      enable = lib.options.mkEnableOption "tsrk's C# development bundle";

      package = lib.options.mkPackageOption pkgs ".NET" {
        default = [ "dotnet-sdk_8" ];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.packages = with pkgs;
      [
        cfg.package
        mono
        msbuild
        roslyn
      ];

    environment.sessionVariables = {
      DOTNET_ROOT = "${cfg.package}";
      DOTNET_CLI_TELEMETRY_OPTOUT = "true";
    };
  };
}
