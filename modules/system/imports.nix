[
  { path = ./network/hostname.nix; }
  ./network/networkmanager.nix
  { path = ./packages; }
  ./programs/gamescope.nix
  { path = ./services/audio.nix; }
  ./services/hardware/bluetooth.nix
  ./services/hardware/disks.nix
  ./services/networking/sshd
  ./services/virtualisation/containers
  ./services/virtualisation/libvirt.nix
  ./services/x11/dipslay-manager/sddm.nix
  ./services/x11/keyboard/qwerty-fr.nix
  ./services/x11/redshift.nix
  ./services/x11/sessions/i3.nix
  ./services/x11/sessions/hyprland.nix
]
