{ lib, config, pkgs, ... }:

{
  options = {
    tsrk.packages.pkgs = {
      gaming = {
        enable = lib.options.mkEnableOption "tsrk's gaming package bundle";
        amdSupport = lib.options.mkEnableOption "AMD support";
      };
    };
  };

  config = lib.mkIf config.tsrk.packages.pkgs.gaming.enable (lib.mkMerge [
    {
      environment.systemPackages = with pkgs; [
        gamemode
      ];

      hardware.steam-hardware.enable = lib.mkDefault true;
      programs.steam = {
        enable = lib.mkDefault true;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
        remotePlay.openFirewall = lib.mkDefault true;
        localNetworkGameTransfers.openFirewall = lib.mkDefault true;
      };
    }
    (lib.mkIf (config.tsrk.packages.pkgs.gaming.amdSupport) {
      hardware.opengl = {
        extraPackages = [ pkgs.amdvlk ];
        extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
      };
    })
  ]);
}