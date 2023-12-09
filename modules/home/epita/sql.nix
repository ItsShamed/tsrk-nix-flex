{ config, pkgs, lib, osConfig ? {}, ... }:

let
  systemReady = if osConfig ? tsrk.packages.pkgs.sql.enable then
    osConfig.tsrk.packages.pkgs.sql.enable else true;
in
{
  options = {
    tsrk.epita.sql = {
      enable = lib.options.mkEnableOption "tsrk's EPITA SQL Workshop Environment";
      dataDir = lib.options.mkOption {
        description = "Path to PostgreSQL data directory.";
        type = lib.types.path;
        default = "${config.home.homeDirectory}/postgres_data";
      };
      socketDir = lib.option.mkOption {
        description = "Path to the directory where the PostgreSQL socket will be stored.";
        type = lib.types.path;
        default = /tmp;
      };
    };
  };

  config = lib.mkIf (systemReady && config.tsrk.epita.sql.enable) {
    systemd.user.services.initdb = {
      Unit = {
        Description = "initdb";
      };

      Service = {
        Type = "oneshot";
        Environment = "PGDATA=${config.tsrk.epita.sql.dataDir}";
        ExecStart = "/run/current-system/sw/bin/initdb --locale \"\$LANG\" -E UTF-8";
        RemainAfterExit = "true";
      };
    };

    systemd.user.services.postgres = {
      Unit = {
        Description = "PostGraisseQL";
        Requires = "initdb.service";
        After = "initdb.service";
      };

      Service = {
        Type = "simple";
        Environment = "PGDATA=${config.tsrk.epita.sql.dataDir}";
        ExecStart = "/run/current-system/sw/bin/postgres -k ${config.home.sessionVariables.PGHOST}";
        Restart = "on-failure";
      };
    };

    home.packages = with pkgs; [
      (writeShellScriptBin "restore_roger" ''
       if [ $# -ne 1 ]; then
       exit 1
       fi

       tar -Oxvf "$1" hello_roger_roger/roger_roger.dump > roger_roger.dump
       shift 1
       pg_restore -U postgres -O -c --if-exists -d roger_roger roger_roger.dump
       '')
        (writeShellScriptBin "setupsql" ''
         createuser -s postgres
         createdb -U postgres roger_roger
         '')
    ];

    home.sessionVariables = {
      PGHOST = "${config.tsrk.epita.sql.socketDir}";
      PGDATA = "${config.tsrk.epita.sql.dataDir}";
    };
  };
}
