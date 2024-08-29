{ inputs, ... }:

name:

{ modules ? [ ]
}:

{ config, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  assertions = [
    {
      assertion = config.users.users ? "${name}";
      message = "Cannot create an Home-Manager configuration for non-existing user \"${name}\"";
    }
    {
      assertion = config.users.users."${name}".createHome;
      message = "Cannot create an Home-Manager configuration for user \"${name}\" while home creation is disabled.";
    }
    {
      assertion = config.users.users."${name}".home != "/var/empty";
      message = "Cannot create an Home-Manager for user \"${name}\" with invalid home path";
    }
  ];

  home-manager.useGlobalPkgs = true;

  home-manager.users."${name}" = {
    imports = modules;
    home.username = name;
    home.homeDirectory = config.users.users."${name}".home;
    home.stateVersion = "24.05";
    programs.home-manager.enable = true;
  };
}
