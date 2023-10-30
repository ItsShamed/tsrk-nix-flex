name:

{
  password ? null,
  passwordFile ? null,
  initialPassword ? ""
}:

{
  users.users.${name} = {
    inherit name;
    inherit passwordFile password initialPassword;
    isNormalUser = true;
  };
}
