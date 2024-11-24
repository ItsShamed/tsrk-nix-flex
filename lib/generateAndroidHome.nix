{ self, inputs, pkgSet, ... }:

let
  name = "nix-on-droid";
in

{ modules ? [ ]
}:

{
  home-manager.useGlobalPkgs = true;

  home-manager.config = {
    home.username = name;
    home.stateVersion = "24.05";
    programs.home-manager.enable = true;
  };

  home-manager.sharedModules = modules ++ [ inputs.nixvim.homeManagerModules.nixvim ];

  home-manager.extraSpecialArgs = {
    inherit self;
    inherit inputs;
    inherit (inputs) home-manager;
    inherit (pkgSet) pkgsUnstable;
    hmLib = inputs.home-manager.lib.hm;
    vimHelpers = import "${inputs.nixvim}/lib/helpers.nix" {
      inherit (inputs.nixpkgs) lib;
      inherit (pkgSet) pkgs;
      _nixvimTests = false;
    };
  };
}
