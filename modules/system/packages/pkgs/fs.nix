{ config, lib, pkgs, ... }:

{
  options = {
    tsrk.packages.fs.enable = lib.options.mkEnableOption "tsrk's filesystem package bundle";
  };

  config = lib.mkIf config.tsrk.packages.fs.enable {
    environment.systemPackages = with pkgs; [
      fuse
      fuse3
      fuseio
      sshfs

      ntfs3g # To transfer Windows backups
    ];
  };
}
