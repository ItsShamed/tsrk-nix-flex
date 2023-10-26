{ config, lib, pkgs, ... }:

let
  cfg = config.tsrk.packages.csharp;
in
{
  option = {
    tsrk.packages.pkgs.csharp = {
      enable = lib.options.mkEnableOption "tsrk's C# development bundle";

      package = lib.options.mkPackageOption pkgs ".NET" {
        default = pkgs.dotnet-sdk_7;
      };

      ide = {
        enable =
          (lib.options.mkEnableOption "the .NET IDE")
          // {
            default = true;
          };

        package = lib.options.mkPackageOption pkgs ".NET IDE" {
          default =
            pkgs.jetbrains.rider; # Sorry not sorry, school free license is yummy
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
        rolsyn
      ]
      ++ (lib.lists.optional cfg.ide.enable cfg.ide.package);

    environment.variables = {
      DOTNET_ROOT = "${cfg.package}";
      DOTNET_CLI_TELEMETRY_OPTOUT = "true";
    };
  };
}
