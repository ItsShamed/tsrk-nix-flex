{ config, lib, pkgs, ... }:

{
  options = {
    tsrk.packages.pkgs.base = {
      enable = lib.options.mkEnableOption "tsrk's base package bundle";
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
        git-crypt
        wget
        diffutils

        inetutils
        utillinux
        coreutils-full

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

        # Basic editor
        vim
      ];
    })
  ];
}
