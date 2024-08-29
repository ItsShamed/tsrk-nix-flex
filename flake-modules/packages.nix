{ lib, ... }:

{
  perSystem = { pkgs, system, ... }: {
    formatter = pkgs.nixpkgs-fmt;
    packages = (import ../pkgs { inherit lib pkgs system; });
  };
}
