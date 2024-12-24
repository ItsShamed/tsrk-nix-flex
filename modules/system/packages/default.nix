args:

{ lib, ... }:

{
  imports = [ (lib.modules.importApply ./pkgs args) ];
}
