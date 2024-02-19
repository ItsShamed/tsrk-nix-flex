{ config, lib, pkgs, ... }:

{
  programs.nixvim = {
    plugins.project-nvim = {
      enable = true;
      detectionMethods = [ "pattern" ];
      manualMode = false;

      ignoreLsp = [ ];
      showHidden = false;
      silentChdir = true;
      scopeChdir = "global";

      extraOptions = {
        patterns = [
          ".git"
          "Makefile"
          "package.json"
          "pom.xml"
          "Cargo.toml"
          "go.mod"
          "*.sln"
        ];
      };
    };
  };
}
