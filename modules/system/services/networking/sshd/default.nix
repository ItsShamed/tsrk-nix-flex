{ config, lib, ... }:

{
  options = {
    tsrk.sshd = {
      enable = lib.options.mkEnableOption "OpenSSH daemon";
      customKeyPair = lib.options.mkEnableOption "custom SSH Host keypairs";
    };
  };

  config = lib.mkIf config.tsrk.sshd.enable (lib.mkMerge
    [
      {
        services.openssh = {
          enable = true;
          settings = {
            X11Forwarding = true;
            PasswordAuthentication = false;
            KbdInteractiveAuthentication = false;
          };
        };
      }
    ] ++ (lib.lists.optional config.tsrk.sshd.customKeyPair {
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

    environment.etc = {
      # Private keys
      "ssh/ssh_host_rsa_key" = {
        source = config.age.secrets.ssh_host_rsa_key.path;
        mode = "0600";
      };
      "ssh/ssh_host_ed25519_key" = {
        source = config.age.secrets.ssh_host_ed25519_key.path;
        mode = "0600";
      };

      # Public keys
      "ssh/ssh_host_rsa_key.pub" = {
        source = ./ssh_host_rsa_key.pub;
        mode = "0600";
      };
      "ssh/ssh_host_ed25519_key.pub" = {
        source = ./ssh_host_ed25519_key.pub;
        mode = "0600";
      };
    };
  }));
}
