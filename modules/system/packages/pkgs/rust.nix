{ config, lib, pkgs, ... }:

{
  options = {
    tsrk.packages.pkgs.rust = {
      enable = lib.options.mkEnableOption "tsrk's Rust bundle";
    };
  };

  config = config.tsrk.packages.pkgs.rust.enable {
    environment.systemPackages = with pkgs; [
      cargo
      rustc
      rustup
      rustfmt
      clippy
    ];
  };
}
