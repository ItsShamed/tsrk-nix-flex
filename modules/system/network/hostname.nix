{ config
, lib
, ...
}: {
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
        description = "Whether to remove the suffix identifying the image you are using.";
        default = false;
      };
    };
  };

  config = lib.mkIf tsrk.networking.hostname.useDHCPHostname {
    networking.hostName = lib.mkForce "";
  };
}
