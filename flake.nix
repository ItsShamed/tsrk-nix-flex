{
  description = ''
    Opinionated NixOS base configuration.
  '';

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgsUnstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    futils.url = "github:numtide/flake-utils";
    flake-parts.url = "github:hercules-ci/flake-parts";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    nix-gaming.url = "github:fufexan/nix-gaming";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spotify-notifyx = {
      url = "github:ItsShamed/spotify-dbus-enhancer/master";
    };

    agenix.url = "github:ryantm/agenix";
  };

  outputs = { futils, flake-parts, ... } @ inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {

      imports = [ ./flake-modules ];

      systems = futils.lib.defaultSystems;
    };
}
