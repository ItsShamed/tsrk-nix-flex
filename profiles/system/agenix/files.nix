{ inputs, ... }:

{
  imports = [
    inputs.agenix.nixosModules.default
  ];

  age.secrets = {
    ssh_host_ed25519_key = {
      file = ./ssh_host_ed25519_key.age;
      mode = "600";
    };
    ssh_host_rsa_key = {
      file = ./ssh_host_rsa_key.age;
      mode = "600";
    };
  };
}
