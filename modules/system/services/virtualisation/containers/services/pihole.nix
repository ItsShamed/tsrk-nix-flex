{ config, lib, ... }:

let
  cfg = config.tsrk.containers.services.pihole;
  dnsPorts = lib.lists.flatten (
    builtins.map
      (ip: [ "${ip}:53:53/tcp" "${ip}:53:53/udp" ])
      cfg.exposeTo);
in
{
  options = {
    tsrk.containers.services = {
      pihole = {
        enable = lib.options.mkEnableOption "PiHole docker container";
        exposeTo = lib.options.mkOption {
          description = "IP addresses to expose PiHole to";
          type = with lib.types; listOf str;
          default = [
            "127.0.0.53"
          ];
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = [
        8053
        53
      ];
      allowedUDPPorts = [ 53 ];
    };

    virtualisation.oci-containers.containers.pihole = {
      image = "pihole/pihole:2024.07.0";
      ports = [
        "3080:80"
        "30443:443"
      ] ++ dnsPorts;
      volumes = [
        "/var/lib/pihole/:/etc/pihole/"
        "/var/lib/dnsmasq.d/:/etc/dnsmasq.d/"
      ];
      environment = {
        ServerIP = "127.0.0.53";
      };
      extraOptions = [
        "--cap-add=NET_ADMIN"
        "--dns=127.0.0.1"
        "--dns=1.1.1.1"
        "--dns=1.0.0.1"
      ];
    };
  };
}
