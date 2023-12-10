{ config, lib, pkgs, ... }:

{
  imports = [
    ./lazygit.nix
  ];

  programs.git = {
    enable = true;
    lfs = lib.mkDefault true;
    signing = {
      signByDefault = lib.mkDefault true;
      key = lib.mkDefault "D1C2AD054267D54D248A4F43EBD46BB3049B56D6";
    };
    userName = lib.mkDefault "tsrk.";
    userEmail = lib.mkDefault "tsrk@tsrk.me";
  };
}