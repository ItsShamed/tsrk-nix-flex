{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    aria2
    qbittorrent
    miru
    tailscale
  ];

  services.tailscale.enable = true;
  services.tailscale.openFirewall = true;
}
