{ config, lib, pkgs, ... }:

let cfg = config.tsrk.premid;
in {
  options = {
    tsrk.premid = {
      enable = lib.options.mkEnableOption "PreMiD";
      sandbox = lib.options.mkEnableOption "Electron's sandbox";
      package =
        lib.options.mkPackageOption pkgs "PreMiD" { default = [ "premid" ]; };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ premid ];

    systemd.user.services = {
      premid = {
        Unit = {
          Requires = "graphical-session.target";
          After = "graphical-session.target";
          Description = "PreMiD IPC client daemon";
          Documentation = [ "https://docs.premid.app" ];
        };

        Service = {
          ExecStart = "${lib.meta.getExe cfg.package}${
              lib.strings.optionalString (!cfg.sandbox) " --no-sandbox"
            }";
        };

        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
