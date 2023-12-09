{ config, lib, pkgs, ... }:

{
  programs.nixvim = {
    plugins.comment-nvim = {
      enable = true;
      ignore = "^s";
      padding = true;
      sticky = true;
      mappings.basic = true;
      mappings.extra = true;
    };
  };
}
