{ self, ... }:

{
  imports = with self.homeManagerModules; [
    profile-shell
    packages
    ssh
  ];

  home.file."tsrk-nix-flex".source = "${self}";
}
