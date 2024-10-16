{ self, ... }:

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

  tsrk.packages = {
    pkgs = {
      ops.enable = true;
      cDev.enable = true;
      go.enable = true;
      python.enable = true;
    };
  };
}
