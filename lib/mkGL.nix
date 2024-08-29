{ withSystem }:

pkgs: config: command:

withSystem pkgs.stdenv.hostPlatform.system ({ inputs', ... }:
if (config.targets.genericLinux.enable) then
  "${inputs'.nixgl.default}/bin/nixGL ${command}"
else
  command
)
