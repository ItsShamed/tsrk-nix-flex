{
  config,
  lib,
  pkgs,
  ...
}: {
  option = {
    tsrk.packages.pkgs.csharp = {
      enable = lib.options.mkEnableOption "tsrk's C# development bundle";

      package = lib.options.mkOption {
        type = lib.types.package;
        default = pkgs.dotnet-sdk_7;
        description = ".NET package to use";
      };

      ide = {
        enable =
          (lib.option.mkEnableOption "the .NET IDE")
          // {
            default = true;
          };

        package = lib.options.mkOption {
          type = lib.types.package;
          default =
            pkgs.jetbrains.rider; # Sorry not sorry, school free license is yummy
          description = "The .NET IDE to use";
        };
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.tsrk.packages.pkgs.csharp.enable {
      environment.systemPackages = with pkgs; [
        config.tsrk.packages.pkgs.csharp.package
        mono
        msbuild
        rolsyn
      ];

      environment.variables = {
        DOTNET_ROOT = "${config.tsrk.packages.pkgs.csharp.package}";
      };
    })

    (lib.mkIf config.tsrk.packages.csharp.ide.enable {
      environment.systemPackages = with pkgs; [config.tsrk.packages.pkgs.csharp.ide.package];
    })
  ];
}
