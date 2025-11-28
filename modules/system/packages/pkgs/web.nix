{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.tsrk.packages.pkgs.web;
in
{
  options = {
    tsrk.packages.pkgs.web = {
      enable = lib.options.mkEnableOption "tsrk's web development bundle";
      ide = {
        package = lib.options.mkPackageOption pkgs "Web IDE" {
          default = [
            "jetbrains"
            "webstorm"
          ];
        };
        enable = (lib.options.mkEnableOption "a Web IDE") // {
          default = false;
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages =
      with pkgs;
      [
        nodejs
        bun
        yarn
        pnpm
      ]
      ++ (lib.lists.optional cfg.ide.enable cfg.ide.package);
  };
}
