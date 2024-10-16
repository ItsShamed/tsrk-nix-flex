{ config, lib, pkgs, ... }:

let
  cfg = config.tsrk.packages.pkgs.sql;
in
{
  options = {
    tsrk.packages.pkgs.sql = {
      enable = lib.options.mkEnableOption "tsrk's PostgreSQL bundle";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.packages = with pkgs; [
      postgresql
      sqlfluff
    ];

    # environment.pathsToLink = [
    #   "/share/postgresql"
    # ];
  };
}
