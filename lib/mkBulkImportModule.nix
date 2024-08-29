{ lib, inputs, self, withSystem, moduleWithSystem, ... }:

{ prefix ? "", path, generateAll ? true, localModules ? self.nixosModules }:

# Asserting this here so that it evaluates `localModules` here and avoids
# triggering a potential infinite recursion due to evaluating `self` multiple
# times during module evaluation.
assert lib.assertMsg (builtins.isAttrs localModules) "localModules is not an attrset.";

let
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

  injectFileLoc = module: file:
    if builtins.isAttrs module then module // { _file = file; key = file; }
    else assert lib.assertMsg (builtins.isFunction module) "${file} is not a module.";
    let
      mirrorArgs = lib.mirrorFunctionArgs module;
    in
    mirrorArgs (origArgs:
      let
        result = module origArgs;
      in
      assert lib.assertMsg (builtins.isAttrs result) "${file} is not a module.";
      result // { _file = file; key = file; }
    );

  importLocal = file: import file {
    inherit importLocal inputs self withSystem fileModuleWithSystem localModules;
  };

  prefix' = if prefix == "" then "" else prefix + "-";

  mkImport = file: {
    _type = "tsrk-appliedModule";
    name = prefix' + lib.strings.removeSuffix ".nix" (builtins.baseNameOf file);
    value = injectFileLoc (warnInexistent importLocal file) file;
  };

  mkModuleWithSystem = file: {
    _type = "tsrk-appliedModule";
    name = prefix' + lib.strings.removeSuffix ".nix" (builtins.baseNameOf file);
    value = injectFileLoc (warnInexistent fileModuleWithSystem file) file;
  };

  importFile = file: {
    name = prefix' + lib.strings.removeSuffix ".nix" (builtins.baseNameOf file);
    value = injectFileLoc (warnInexistent builtins.import file) file;
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
    ** apply needed arguments. Otherwise just import it as is.
    */
    if builtins.isFunction imports' then
      imports'
        {
          inherit
            importLocal mkImport inputs self withSystem fileModuleWithSystem
            mkModuleWithSystem;
        } else imports';
in
builtins.listToAttrs (builtins.map importModule imports)
  // (if generateAll then { all = { ... }: { inherit imports; }; } else { })
