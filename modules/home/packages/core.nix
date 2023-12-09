{ pkgs, ... }:

{
  home.packages = with pkgs; [
    btop
    delta
    lsd
    git-crypt
  ];

  home.shellAliases = {
    l = "lsd -lah";
    ls = "lsd";
    cat = "bat";
  };

  programs.zsh.shellAliases = {
    l = "lsd -lah";
    ls = "lsd";
    cat = "bat";
  };
}
