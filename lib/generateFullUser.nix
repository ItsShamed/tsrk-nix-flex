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
} @ setup:

{
  imports = [
    generateSystemHome name { inherit (setup) modules system homeDir; }
    generateUser name { inherit (setup) password passwordFile canSudo moreGroups; }
  ];
}
