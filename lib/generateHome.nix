{ inputs, withSystem, ... }:

name:

{ modules ? [ ]
, system ? "x86_64-linux"
, homeDir ? "/home/${name}"
}:

let
  homeManagerBase = { ... }: {
    home.username = name;
    home.homeDirectory = homeDir;
    home.stateVersion = "24.05";
    programs.home-manager.enable = true;
  };

  configuration = withSystem system ({ pkgs, ... }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = modules ++ [
        homeManagerBase
      ];
    });
in
configuration
