{ prefix ? "", path, generateAll ? true }:

{ lib, flake-parts-lib, inputs, self, withSystem, moduleWithSystem, ... }:

let
  inherit (flake-parts-lib) importApply;

  fileModuleWithSystem = path: moduleWithSystem (import path);

  deprecationModule = file: { ... }: {
    config.warnings = [
      ''
        This module located at ${file} has been deleted. It has been replaced with a dummy module to avoid breaking as much as possible.
        As such, it currently does nothing. Please remove it as soon as possible, as it might get removed soon.
      ''
    ];
  };

  warnInexistent = apply: file:
    if builtins.pathExists file then apply file
    else
      lib.warn ''
        The module located at ${file} is non-existent, and has been replaced with the deprecation module.
        Do not forget to remove it from the imports file, if that was the intent.
      ''
        (deprecationModule file);

  importApplyLocal = file: importApply file {
    inherit importApplyLocal inputs self withSystem fileModuleWithSystem;
  };

  prefix' = if prefix == "" then "" else prefix + "-";

  mkImportApply = file: {
    _type = "tsrk-appliedModule";
    name = prefix' + lib.strings.removeSuffix ".nix" (builtins.baseNameOf file);
    value = warnInexistent importApplyLocal file;
  };

  mkModuleWithSystem = file: {
    _type = "tsrk-appliedModule";
    name = prefix' + lib.strings.removeSuffix ".nix" (builtins.baseNameOf file);
    value = warnInexistent fileModuleWithSystem file;
  };

  importFile = file: {
    name = prefix' + lib.strings.removeSuffix ".nix" (builtins.baseNameOf file);
    value = warnInexistent builtins.import file;
  };

  importModule = maybeModule:
    if builtins.isPath maybeModule then importFile maybeModule
    else if builtins.isAttrs maybeModule then
      if ((maybeModule._type or "" == "tsrk-appliedModule") || (maybeModule ? name && maybeModule ? value))
      then { inherit (maybeModule) name value; } else throw "Invalid applied module"
    else throw "Invalid applied module";

  imports = let imports' = import path; in
    /*
    ** If the value is in the form
    **
    **  { ... } @ localFlake:
    ** 
    **  [
    **    # Paths
    **  ]
    **
    ** use importApply. Otherwise just import it as is.
    */
    if builtins.isFunction imports' then
      importApply path
        {
          inherit importApplyLocal mkImportApply inputs self withSystem fileModuleWithSystem mkModuleWithSystem;
        } else imports';
in
builtins.listToAttrs (builtins.map importModule imports)
  // (if generateAll then { all = { ... }: { inherit imports; }; } else { })
