args:

{ lib, ... }:

{
  imports = [
    ./core.nix
    ./desktop.nix
    ./dev.nix
    (lib.modules.importApply ./games.nix args)
    ./media.nix
    (lib.modules.importApply ./more-games.nix args)
  ];
}
