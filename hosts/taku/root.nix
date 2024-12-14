{ self, ... }:

{
  imports = with self.homeManagerModules; [
    profile-base
  ];
}
