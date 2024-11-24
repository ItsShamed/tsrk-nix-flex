{ self, pkgs, ... }:

{
  imports = with self.nixOnDroidModules; [
    profile-base
  ];

  environment.etcBackupExtension = ".bak";

  user.shell = "${pkgs.zsh}/bin/zsh";

  tsrk.packages = {
    pkgs = {
      ops.enable = true;
      cDev.enable = true;
      go.enable = true;
      python.enable = true;
    };
  };
}
