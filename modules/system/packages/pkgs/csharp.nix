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

      ide = {
        enable =
          (lib.options.mkEnableOption "the .NET IDE")
          // {
            default = true;
          };

        package = lib.options.mkPackageOption pkgs.jetbrains ".NET IDE" {
          default =
            [ "rider" ]; # Sorry not sorry, school free license is yummy
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [
        cfg.package
        mono
        msbuild
        roslyn
      ]
      ++ (lib.lists.optional cfg.ide.enable cfg.ide.package);

    environment.variables = {
      DOTNET_ROOT = "${cfg.package}";
      DOTNET_CLI_TELEMETRY_OPTOUT = "true";
    };
  };
}
