{ home-manager, pkgsUnstable, self, inputs, ... }:

name:

{
  modules ? [],
  system ? "x86_64-linux",
  homeDir ? "/home/${name}"
}:

let
  pkgsOverride =  {...}: {
    _module.args.pkgs = pkgsUnstable;
  };

  homeManagerBase = {...}: {
    home.username = name;
    home.homeDirectory = homeDir;
    home.stateVersion = "23.05";
    programs.home-manager.enable = true;
  };

  configuration = home-manager.lib.homeManagerConfiguration {
    pkgs = pkgsUnstable;

    modules = modules ++ [ self.homeModules pkgsOverride homeManagerBase ];

    extraSpecialArgs = {
      inherit self;
      gaming = inputs.nix-gaming.packages.${system};
    };
  };
in
configuration
