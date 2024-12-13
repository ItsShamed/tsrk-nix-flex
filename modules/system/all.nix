args:

{ lib, ... }:

{
  imports =
    let
      import' = file:
        if builtins.isAttrs file then
          assert lib.assertMsg (file ? path)
            "structrued module path does not contains `path' attribute";
          lib.importApply file.path args
        else
          file;
      moduleList = import ./imports.nix;
      modules = builtins.map import' moduleList;
    in
    modules;
}
