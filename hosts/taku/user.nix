{ self, ... }:

{
  imports = with self.homeManagerModules; [
    packages
    profile-tsrk-common
    profile-tsrk-private
  ];

  tsrk = {
    packages = {
      # TODO: re-enable after installation
      # games.enable = true;
      # more-gaming.enable = true;
    };
    nvim.wakatime.enable = true;
  };
}
