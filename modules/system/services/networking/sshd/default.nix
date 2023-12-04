{ config, lib, options, ... }:
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

  checkKey = algo: keyType: against:
    let
      cfg = config.tsrk.sshd.customKeyPair."${algo}"."${keyType}";
    in
    lib.trivial.warnIf (cfg == against) "using default ${algo} SSH host keys. DO NOT USE THIS IN PRODUCTION!!!!" cfg;
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
          default = {
            private = ./ssh_host_rsa_key;
            public = ./ssh_host_rsa_key.pub;
          };
        };
        ed25519 = lib.options.mkOption {
          description = "The ED25519 keypair";
          type = lib.types.submodule keypair;
          default = {
            private = ./ssh_host_ed25519_key;
            public = ./ssh_host_ed25519_key.pub;
          };
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
      (lib.mkIf config.tsrk.sshd.customKeyPair.enable {

          environment.etc = {
            # Private keys
            "ssh/ssh_host_rsa_key" = {
              source = checkKey "rsa" "private" ./ssh_host_rsa_key;
              mode = "0600";
            };
            "ssh/ssh_host_ed25519_key" = {
              source = checkKey "ed25519" "private" ./ssh_host_ed25519_key;
              mode = "0600";
            };

            # Public keys
            "ssh/ssh_host_rsa_key.pub" = {
              source = checkKey "rsa" "public" ./ssh_host_rsa_key.pub;
              mode = "0600";
            };
            "ssh/ssh_host_ed25519_key.pub" = {
              source = checkKey "ed25519" "public" ./ssh_host_ed25519_key.pub;
              mode = "0600";
            };
          };
        })
    ]);
}
