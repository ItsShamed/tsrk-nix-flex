{ inputs, ... }:

{
  imports = [
    inputs.agenix.nixosModules.default
  ];

  age.secrets = {
    ssh_host_ed25519_key = {
      file = ./files/ssh_host_ed25519_key.age;
      mode = "600";
    };
    ssh_host_rsa_key = {
      file = ./files/ssh_host_rsa_key.age;
      mode = "600";
    };
    zpasswd = {
      file = ./files/passwd.age;
      mode = "600";
    };
  };
}
