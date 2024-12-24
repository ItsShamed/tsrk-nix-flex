{ generateSystemHome, generateUser, ... }:

name:

{ modules ? [ ], homeDir ? "/home/${name}"

, password ? null, hashedPasswordFile ? null, canSudo ? false, moreGroups ? [ ]
}:

{
  _file = ./generateFullUser.nix;
  key = ./generateFullUser.nix + ".${name}";

  imports = [
    (generateSystemHome name { inherit modules homeDir; })
    (generateUser name {
      inherit password hashedPasswordFile canSudo moreGroups;
    })
  ];
}
