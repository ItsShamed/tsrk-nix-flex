{ config, lib, pkgs, ... }:

let
  cfg = config.tsrk.pacakges.pkgs.sql;
in
{
  options = {
    tsrk.packages.pkgs.sql = {
      enable = lib.options.mkEnableOption "tsrk's PostgreSQL bundle";
      ide = {
        enable = lib.options.mkEnableOption "an SQL Client";
        package = lib.options.mkPackageOption pkgs.jetbrains "the SQL Client" {
          default = [ "datagrip" ];
          example = "pkgs.dbeaver";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      postgresql
      sqlfluff
    ] ++ (lib.lists.optional cfg.ide.enable cfg.ide.package);

    environment.pathsToLink = [
      "/share/postgresql"
    ];
  };
}
