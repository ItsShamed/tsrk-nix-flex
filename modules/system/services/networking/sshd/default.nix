{ config, lib, ... }:
let
  keypair = {
    options = {
      private = lib.options.mkOption {
        type = lib.types.path;
        description = "Private key";
      };
      public = lib.options.mkOption {
        type = lib.types.path;
        description = "Public key";
      };
    };
  };
in
{
  options = {
    tsrk.sshd = {
      enable = lib.options.mkEnableOption "OpenSSH daemon";
      customKeyPair = {
        enable = lib.options.mkEnableOption "custom SSH Host keypairs";
        rsa = lib.options.mkOption {
          description = "The RSA keypair";
          type = lib.types.submodule keypair;
        };
        ed25519 = lib.options.mkOption {
          description = "The ED25519 keypair";
          type = lib.types.submodule keypair;
        };
      };
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
        source = config.tsrk.sshd.customKeyPair.rsa.private;
        mode = "0600";
      };
      "ssh/ssh_host_ed25519_key" = {
        source = config.tsrk.sshd.customKeyPair.ed25519.private;
        mode = "0600";
      };

      # Public keys
      "ssh/ssh_host_rsa_key.pub" = {
        source = config.tsrk.sshd.customKeyPair.rsa.public;
        mode = "0600";
      };
      "ssh/ssh_host_ed25519_key.pub" = {
        source = config.tsrk.sshd.customKeyPair.ed25519.public;
        mode = "0600";
      };
    };
  }));
}
