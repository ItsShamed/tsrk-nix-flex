{ config, lib, pkgs, ... }:

let
  delta-repo = pkgs.fetchFromGitHub {
    owner = "dandavinson";
    repo = "delta";
    rev = "fdfcc8fce30754a4f05eeb167a15d519888fc909";
  };
in
{
  imports = [
    ./lazygit.nix
  ];

  programs.git = {
    enable = true;
    lfs.enable = lib.mkDefault true;
    delta.enable = lib.mkDefault true;
    signing = {
      signByDefault = lib.mkDefault true;
      key = lib.mkDefault "D1C2AD054267D54D248A4F43EBD46BB3049B56D6";
    };
    userName = lib.mkDefault "tsrk.";
    userEmail = lib.mkDefault "tsrk@tsrk.me";
    includes = [{ path = "${delta-repo}/themes.gitconfig"; }];
  };
}
