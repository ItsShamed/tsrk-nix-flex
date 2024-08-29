{ generateSystemHome, generateUser, ... }:

name:

{ modules ? [ ]

, password ? null
, hashedPasswordFile ? null
, canSudo ? false
, moreGroups ? [ ]
}:

{
  imports = [
    (generateSystemHome name { inherit modules; })
    (generateUser name { inherit password hashedPasswordFile canSudo moreGroups; })
  ];
}
