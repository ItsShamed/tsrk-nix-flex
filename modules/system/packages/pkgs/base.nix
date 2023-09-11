{ config, lib, pkgs, ... }:

{
  options = {
    tsrk.packages.pkgs.base = {
      enable = lib.mkEnableOption "tsrk's base package bundle";
      additions = lib.mkEnableOption "tsrk's base additions";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.tsrk.packages.pkgs.base.enable {
      environment.systemPackages = with pkgs; [
        # Filesystem/file management
        file
        ncdu
        tree
        unzip
        zip
        lsof
        rsync
        usbutils

        git
        wget
        diffutils

        inetutils
        utillinux

        jq

        man-pages
        man-pages-posix

        # Monitoring
        htop
        iftop
        iotop

        # Multiplexing
        screen
        tmux
      ];
    })

    (lib.mkIf config.tsrk.packages.pkgs.base.additions {
      config.tsrk.packages.pkgs.base.enable = lib.mkDefault true;

      environment.systemPackages = with pkgs; [
        btop
        lazygit
        delta
      ];
    })
  ];
}
