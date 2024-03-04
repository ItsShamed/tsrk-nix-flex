{ config, lib, pkgs, ... }:

let
  delta-repo = pkgs.fetchFromGitHub {
    owner = "dandavison";
    repo = "delta";
    rev = "fdfcc8fce30754a4f05eeb167a15d519888fc909";
    hash = "sha256-lj/HVcO0gDCdGLy0xm+m9SH4NM+BT3Jar6Mv2sKNZpQ=";
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
