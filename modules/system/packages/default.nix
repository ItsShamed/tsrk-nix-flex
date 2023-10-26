{ inputs, ... }:

{
  imports = [
    ./pkgs
    inputs.epita-forge.nixosModules.packages
  ];
}
