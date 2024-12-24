{ config, lib, pkgs, ... }:

let cfg = config.tsrk.packages.pkgs.ops;
in {
  options = {
    tsrk.packages.pkgs.ops = {
      enable = lib.options.mkEnableOption "tsrk's Ops bundle";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ansible
      opentofu
      kubectl
      kustomize
      k9s
      postgresql
      sqlfluff
      vault-bin
      kubernetes-helm
    ];

    environment.pathsToLink = [ "/share/postgresql" ];
  };
}
