name:

{ password ? null
, hashedPasswordFile ? null
, initialPassword ? null
, canSudo ? false
, moreGroups ? [ ]
,
}:

{ lib, ... }:

{
  _file = ./generateUser.nix;
  key = ./generateUser.nix + ".${name}";

  users.users."${name}" = {
    inherit name;
    inherit hashedPasswordFile password initialPassword;
    isNormalUser = true;
    extraGroups = [ "video" "audio" "input" "networkmanager" ]
      ++ (lib.lists.optional canSudo "wheel")
      ++ moreGroups;
  };
}
