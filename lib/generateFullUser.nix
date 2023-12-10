{ self, inputs, pkgSet, generateSystemHome, generateUser, ... }:

name:

{ modules ? [ ]
, system ? "x86_64-linux"
, homeDir ? "/home/${name}"

, password ? null
, passwordFile ? null
, initialPassword ? ""
, canSudo ? false
, moreGroups ? [ ]
}:

{
  imports = [
    (generateSystemHome name { inherit modules system homeDir; })
    (generateUser name { inherit password passwordFile canSudo moreGroups; })
  ];
}
