{ generateSystemHome, generateUser, ... }:

name:

{ modules ? [ ]
, homeDir ? "/home/${name}"

, password ? null
, hashedPasswordFile ? null
, canSudo ? false
, moreGroups ? [ ]
}:

{
  imports = [
    (generateSystemHome name { inherit modules homeDir; })
    (generateUser name { inherit password hashedPasswordFile canSudo moreGroups; })
  ];
}
