{ self, ... }:

{
  imports = with self.nixOnDroidModules; [
    profile-tsrk-common
  ];

  user = rec {
    uid = 10704;
    gid = uid;
  };
}
