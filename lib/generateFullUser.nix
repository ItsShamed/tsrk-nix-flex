{ generateSystemHome, generateUser, ... }:

name:

{ modules ? [ ]
, system ? "x86_64-linux"
, homeDir ? "/home/${name}"

, password ? null
, hashedPasswordFile ? null
, canSudo ? false
, moreGroups ? [ ]
}:

{
  imports = [
    (generateSystemHome name { inherit modules system homeDir; })
    (generateUser name { inherit password hashedPasswordFile canSudo moreGroups; })
  ];
}
