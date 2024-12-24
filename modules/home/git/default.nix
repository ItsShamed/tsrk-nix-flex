args:

{ config, lib, ... }:

{
  imports =
    [ ./cli.nix ./delta.nix (lib.modules.importApply ./lazygit.nix args) ];

  options = {
    tsrk.git.enable = lib.options.mkEnableOption "tsrk's Git configuration";
  };

  config = lib.mkIf config.tsrk.git.enable {
    warnings = (lib.mkIf (config.programs.git.userEmail == null) [''
      You didn't set an e-mail in your Git config. If it is intended, don't
      forget to set it manually afterwards. Otherwise, you won't be able to
      use Git.
    '']);
    programs.git = {
      enable = true;
      lfs.enable = lib.mkDefault true;
      userName = lib.mkDefault "${config.home.username}";
      extraConfig = { init.defaultBranch = "main"; };
    };
  };
}
