{ config, pkgs, lib, ... }:

{
  options = {
    tsrk.git.cli = {
      enable = lib.options.mkEnableOption "tsrk's Git CLI utils bundle";
    };
  };

  config = lib.mkIf config.tsrk.git.cli.enable {
    programs.gh = {
      enable = lib.mkDefault true;
      extensions = [
        # TODO
      ];
      settings = {
        editor = "nvim";
        git_protocol = "ssh";
      };
    };
    home.packages = with pkgs; [
      glab
    ];
  };
}
