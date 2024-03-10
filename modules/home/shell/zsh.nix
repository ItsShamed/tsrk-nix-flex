{ config, lib, pkgs, ... }:

{
  programs.zsh.enable = true;
  programs.zsh.shellAliases = {
    l = "lsd -lah";
    lg = "lazygit";
    ls = "lsd";
  };
  programs.zsh.enableAutosuggestions = true;
  programs.zsh.syntaxHighlighting.enable = true;
  programs.zsh.autocd = true;

  programs.zsh.initExtra = ''
    bindkey -v
    ${pkgs.fastfetch}/bin/fastfetch
  '';
}
