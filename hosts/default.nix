{ lib, self, withSystem, inputs, ... }:

let
  generateSystem = module:
    let
      imageName = lib.strings.removeSuffix ".nix" (builtins.baseNameOf module);
      system =
        if builtins.pathExists "${module}/system"
        then builtins.readFile module else "x86_64-linux";
      modules =
        let
          global = withSystem system ({ pkgs, ... }:
            { ... }:
            {
              system.name = imageName;
              nix.nixPath = [
                "nixpkgs=${inputs.nixpkgs}"
                "nixpkgsUnstable=${inputs.nixpkgs}"
                "nixos-config=${module}"
                "tsrk=${self}"
                "/nix/var/nix/profiles/per-user/root/channels"
              ];

              nix.registry = {
                nixpkgs.flake = inputs.nixpkgs;
                nixpkgsUnstable.flake = inputs.nixpkgsUnstable;
                tsrk.flake = self;
                # nixpkgsMaster.flake = nixpkgsMaster;
              };

              nixpkgs = {
                inherit pkgs;
              };

              networking.hostName = "tsrk-" + imageName;
            }
          );
          imported = import module;
        in
        [ global imported ];
    in
    {
      name = imageName;
      value = inputs.nixpkgs.lib.nixosSystem {
        inherit system modules;
      };
    };
in
{
  flake.nixosConfigurations =
    builtins.listToAttrs (builtins.map generateSystem (import ./hosts.nix));
}
