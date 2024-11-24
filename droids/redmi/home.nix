{ self, ... }:

{
  imports = with self.homeManagerModules; [
    profile-tsrk-android
  ];
}
