{ config, lib, pkgs, ... }:

let
  cfg = config.tsrk.libvirt;
in
{
  options = {
    tsrk.libvirt = {
      enable = lib.options.mkEnableOption "libvirt";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = with pkgs; [
            OVMFFull.fd
          ];
        };
      };
    };

    programs.virt-manager.enable = lib.mkDefault true;

    environment.systemPackages = with pkgs; [
      libguestfs
    ];
  };
}
