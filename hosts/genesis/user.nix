{ self, ... }:

{
  imports = with self.homeManagerModules; [
    profile-shell
    packages
  ];

  home.file."tsrk-nix-flex".source = "${self}";
}
