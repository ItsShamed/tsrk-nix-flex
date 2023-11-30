{ config, lib, ... }:

let
  cfg = config.tsrk.redshift;
in
{
  options = {
    tsrk.redshift = {
      enable = lib.options.mkEnableOption "Redshift";
      at = lib.options.mkOption {
        type = lib.types.submodule {
          options = {
            lat = lib.options.mkOption {
              type = lib.types.float;
              description = "The latitude of the location.";
              default = 48.81893553428525;
            };
            long = lib.options.mkOption {
              type = lib.types.float;
              description = "The longitude of the location.";
              default = 2.3596844139022988;
            };
          };
        };
        description = "The location to base Redshift on.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.redshift.enable = true;

    location = {
      latitude = cfg.at.lat;
      longitude = cfg.at.long;
    };
  };
}
