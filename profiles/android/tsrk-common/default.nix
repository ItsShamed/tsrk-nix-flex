{ self, pkgs, ... }:

{
  imports = with self.nixOnDroidModules; [
    profile-base
    (self.generateAndroidHome {
      modules = [
        ./home.nix
      ];
    })
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
