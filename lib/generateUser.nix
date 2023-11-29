name:

{
  password ? null,
  passwordFile ? null,
  initialPassword ? "",
  canSudo ? false,
  moreGroups ? [],
}:

{ lib, ... }:

{
  users.users."${name}" = {
    inherit name;
    inherit passwordFile password initialPassword;
    isNormalUser = true;
    extraGroups = [ "video" "audio" "input" ]
      ++ (lib.lists.optional canSudo "wheel")
      ++ moreGroups;
  };
}
