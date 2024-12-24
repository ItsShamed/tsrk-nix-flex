{ config, lib, ... }:

{
  options = {
    tsrk.redshift = { enable = lib.options.mkEnableOption "redshift"; };
  };

  # Taken from https://gitlab.cri.epita.fr/cri/infrastructure/nixpie/-/blob/master/modules/services/x11/redshift.nix
  config = lib.mkIf config.tsrk.redshift.enable {
    services.redshift = { enable = true; };

    # Used by redshift to determine sunrise and sunset.
    location = {
      latitude = 48.87951;
      longitude = 2.28513;
    };
  };
}
