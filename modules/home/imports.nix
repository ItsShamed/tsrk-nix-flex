{ mkImport, mkModuleWithSystem, ... }:

[
  (mkImport ./desktop/darkman.nix)
  ./desktop/dunst.nix
  ./desktop/flameshot.nix
  (mkImport ./desktop/i3.nix)
  (mkImport ./desktop/kitty.nix)
  (mkImport ./desktop/picom.nix)
  (mkImport ./desktop/polybar.nix)
  ./desktop/premid.nix
  (mkImport ./desktop/rofi.nix)
  ./desktop/thunderbird.nix
  ./desktop/xdg.nix
  (mkImport ./desktop/xsettingsd.nix)
  ./epita
  ./git
  ./git/delta.nix
  ./git/git-cli.nix
  (mkImport ./git/lazygit.nix)
  (mkImport ./nvim)
  (mkImport ./packages)
  ./shell
  ./shell/bash.nix
  (mkModuleWithSystem ./shell/bat.nix)
  ./shell/fastfetch.nix
  ./shell/lsd.nix
  ./shell/starship.nix
  ./shell/zoxide.nix
  ./shell/zsh.nix
  ./ssh.nix
]
