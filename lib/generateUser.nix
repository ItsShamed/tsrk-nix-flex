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
    extraGroups = [ "video" "audio" "input" ]
      ++ (lib.lists.optional canSudo "wheel")
      ++ moreGroups;
  };
}
