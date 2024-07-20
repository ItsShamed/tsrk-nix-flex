{ config, inputs, lib, ... }:

{
  imports = [
    (inputs.agenix.nixosModules.default)
  ];

  options = {
    tsrk.age = {
      bootstrapKeys = lib.options.mkOption {
        description = "Whether to load bootstrap SSH keys into this host";
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = lib.mkIf config.tsrk.age.bootstrapKeys {
    warnings = [
      ''
        Bootstrap SSH keys are loaded on this host. These keys are not supposed
        to be permanent and are intended to be used only to setup agenix on new
        hosts. Also note that only ED25519 SSH keys are loaded as bootstrap
        keys.
      ''
    ];

    tsrk.sshd = {
      customKeyPair = {
        enable = lib.mkDefault true;
        ed25519 = {
          private = lib.mkDefault ./bootstrap-keys/ssh_host_ed25519_key;
          public = lib.mkDefault ./bootstrap-keys/ssh_host_ed25519_key.pub;
        };
      };
    };

    age.identityPaths = [
      ./bootstrap-keys/ssh_host_ed25519_key
    ];
  };
}
