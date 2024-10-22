{ config, lib, ... }:

let
  cfg = config.tsrk.containers.services.pihole;
in
{
  options = {
    tsrk.containers.services = {
      pihole = {
        enable = lib.options.mkEnableOption "PiHole docker container";
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
        "127.0.0.53:53:53/tcp"
        "127.0.0.53:53:53/udp"
        "3080:80"
        "30443:443"
      ];
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
