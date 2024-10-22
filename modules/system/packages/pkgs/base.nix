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
        p7zip
        lsof
        rsync
        usbutils
        pciutils

        git
        pre-commit
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
