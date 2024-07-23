{ self, ... }:

{
  imports = with self.homeManagerModules; [
    profile-shell
    packages
    ssh
  ];
}
