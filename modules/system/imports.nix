{ mkImport, mkModuleWithSystem, ... }:

[
  ./network/hostname.nix
  ./network/networkmanager.nix
  (mkImport ./packages)
  (mkImport ./services/audio.nix)
  ./services/hardware/bluetooth.nix
  ./services/hardware/disks.nix
  ./services/networking/sshd
  ./services/virtualisation/containers
  (mkModuleWithSystem ./services/x11/dipslay-manager/sddm.nix)
  ./services/x11/keyboard/qwerty-fr.nix
  ./services/x11/redshift.nix
  ./services/x11/sessions/i3.nix
  ./services/x11/sessions/hyprland.nix
]
