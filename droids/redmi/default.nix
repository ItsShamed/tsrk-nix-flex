{ self, ... }:

{
  imports = with self.nixOnDroidModules; [
    profile-tsrk-common
    (self.lib.generateAndroidHome {
      modules = [
        ./home.nix
      ];
    })
  ];

  user = rec {
    uid = 10704;
    gid = uid;
  };
}
