{ config, lib, options, ... }:
let
  cfg = config.tsrk.sshd;
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
in {
  options = {
    tsrk.sshd = {
      enable = lib.options.mkEnableOption "OpenSSH daemon";
      customKeyPair = {
        enable = lib.options.mkEnableOption "custom SSH Host keypairs";
        rsa = lib.options.mkOption {
          description = "The RSA keypair";
          type = lib.types.nullOr (lib.types.submodule keypair);
          default = null;
        };
        ed25519 = lib.options.mkOption {
          description = "The ED25519 keypair";
          type = lib.types.submodule keypair;
          default = null;
        };
      };
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
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
    (lib.mkIf cfg.customKeyPair.enable (lib.mkMerge [
      {
        warnings = (lib.mkMerge [
          (lib.mkIf (cfg.customKeyPair.rsa == null) [''
            You enabled SSH host key overrides but did not provide an RSA keypair.
            One will be generated automatically at first boot.
          ''])
          (lib.mkIf (cfg.customKeyPair.ed25519 == null) [''
            You enabled SSH host key overrides but did not provide an ED25519 keypair.
            One will be generated automatically at first boot.
          ''])
        ]);

        services.openssh = {
          hostKeys = (lib.lists.optional (cfg.customKeyPair.rsa == null) {
            bits = 4096;
            path = "/etc/ssh/ssh_host_rsa_key";
            type = "rsa";
          }) ++ (lib.lists.optional (cfg.customKeyPair.ed25519 == null) {
            path = "/etc/ssh/ssh_host_ed25519_key";
            type = "ed25519";
          });
        };
      }
      (lib.mkIf (cfg.customKeyPair.rsa != null) {
        environment.etc = {
          "ssh/ssh_host_rsa_key" = {
            source = cfg.customKeyPair.rsa.private;
            mode = "0600";
          };
          "ssh/ssh_host_rsa_key.pub" = {
            source = cfg.customKeyPair.rsa.public;
            mode = "0600";
          };
        };
      })
      (lib.mkIf (cfg.customKeyPair.ed25519 != null) {
        environment.etc = {
          "ssh/ssh_host_ed25519_key" = {
            source = cfg.customKeyPair.ed25519.private;
            mode = "0600";
          };
          "ssh/ssh_host_ed25519_key.pub" = {
            source = cfg.customKeyPair.ed25519.public;
            mode = "0600";
          };
        };
      })
    ]))
  ]);
}
