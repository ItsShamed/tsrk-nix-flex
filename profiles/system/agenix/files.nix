{ inputs, ... }:

{
  imports = [
    inputs.agenix.nixosModules.default
  ];

  age.secrets = {
    zpasswd = {
      file = ./files/passwd.age;
      mode = "600";
    };
  };
}
