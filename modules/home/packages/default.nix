{ importApplyLocal, ... }:

{
  imports = [
    ./core.nix
    ./desktop.nix
    ./dev.nix
    (importApplyLocal ./games.nix)
    ./media.nix
    (importApplyLocal ./more-games.nix)
  ];
}
