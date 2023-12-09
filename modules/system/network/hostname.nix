{ config, lib, self, host, ... }:

let
  cfg = config.tsrk.networking.hostname;
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
        type = lib.types.str;
        description = "The base hostname to use.";
        default = "tsrk";
      };
      removeImageSuffix = lib.options.mkOption {
        type = lib.types.bool;
        description = "Whether to remove the suffix identifying the host you are using.";
        default = false;
      };
    };
  };

  config = (self.lib.mkIfElse cfg.useDHCPHostname
    {
      networking.hostName = "";
    }
    {
      networking.hostName = cfg.base + (lib.strings.optionalString (!cfg.removeImageSuffix) ("-" + host));
    });
}
