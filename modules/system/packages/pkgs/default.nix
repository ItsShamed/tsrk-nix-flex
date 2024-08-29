{ importApplyLocal, ... }:

{
  imports = [
    ./android.nix
    ./base.nix
    ./cDev.nix
    ./cpp.nix
    ./csharp.nix
    ./desktop.nix
    ./fs.nix
    (importApplyLocal ./gaming.nix)
    ./go.nix
    ./java.nix
    ./python.nix
    ./qmk.nix
    ./rust.nix
    ./sql.nix
  ];
}
