{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    aria2
    qbittorrent
    miru
  ];
}
