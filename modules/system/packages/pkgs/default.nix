args:

{ lib, ... }:

{
  imports = [
    ./android.nix
    ./base.nix
    ./cDev.nix
    ./cpp.nix
    ./csharp.nix
    ./desktop.nix
    ./fs.nix
    (lib.modules.importApply ./gaming.nix args)
    ./go.nix
    ./java.nix
    ./ops.nix
    ./python.nix
    ./qmk.nix
    ./rust.nix
    ./sql.nix
  ];
}
