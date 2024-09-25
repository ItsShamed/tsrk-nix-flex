{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    qbittorrent
    miru
  ];
}
