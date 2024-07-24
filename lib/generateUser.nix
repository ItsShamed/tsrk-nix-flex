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
  users.users."${name}" = {
    inherit name;
    inherit hashedPasswordFile password initialPassword;
    isNormalUser = true;
    extraGroups = [ "video" "audio" "input" "networkmanager" ]
      ++ (lib.lists.optional canSudo "wheel")
      ++ moreGroups;
  };
}
