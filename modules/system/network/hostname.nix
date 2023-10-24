{ config, lib, self, host, ... }:

let
  cfg = config.tsrk.networking;
in
{
  options = {
    tsrk.networking.hostname = {
      useDHCPHostname = lib.options.mkOption {
        type = lib.types.bool;
        description = "Whether to use the hostname provided by DHCP.";
        default = false;
      };
      base = lib.options.mkOption {
        type = lib.types.string;
        description = "The base hostname to use.";
        default = "tsrk";
      };
      removeImageSuffix = lib.option.mkOption {
        type = lib.types.bool;
        description = "Whether to remove the suffix identifying the host you are using.";
        default = false;
      };
    };
  };

  config = {
    networking.hostName = (self.mkIfElse cfg.useDHCPHostname
      ""
      cfg.base + (lib.strings.optionalString (!cfg.removeImageSuffix) ("-" + host))
    );
  };
}
