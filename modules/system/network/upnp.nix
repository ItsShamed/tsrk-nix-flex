# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.tsrk.networking.upnp;
  fwCfg = config.networking.firewall;
in
{
  options = {
    tsrk.networking.upnp = {
      enable = lib.options.mkEnableOption "firewalls rules for allowing UPnP";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      (lib.mkIf (fwCfg.backend == "iptables") {
        networking.firewall = {
          extraCommands = ''
            # Add ipset to match by source IP and port
            ${pkgs.ipset}/bin/ipset create nixos-fw-upnp hash:ip,port timeout 3 || true
            ${pkgs.ipset}/bin/ipset create nixos-fw-upnp-6 hash:ip,port timeout 3 family inet6 || true

            # Add hashs of source IP and port of outgoing SSDP requests to ipset
            iptables -A OUTPUT -d 239.255.255.250/32 -p udp -m udp --dport 1900 -j SET --add-set nixos-fw-upnp src,src --exist
            ip6tables -A OUTPUT -d ff05::c/128 -p udp -m udp --dport 1900 -j SET --add-set nixos-fw-upnp-6 src,src --exist
            ip6tables -A OUTPUT -d ff02::c/128 -p udp -m udp --dport 1900 -j SET --add-set nixos-fw-upnp-6 src,src --exist

            # Add incoming UPnP rules to match SSDP source IP and port
            iptables -I nixos-fw -p udp -m set --match-set nixos-fw-upnp dst,dst -j nixos-fw-accept
            ip6tables -I nixos-fw -p udp -m set --match-set nixos-fw-upnp-6 dst,dst -j nixos-fw-accept
          '';

          extraStopCommands = ''
            ${pkgs.ipset}/bin/ipset destroy nixos-fw-upnp || true
            ${pkgs.ipset}/bin/ipset destroy nixos-fw-upnp-6 || true
          '';
        };
      })
    ]
  );
}
