{ config, ... }:

{
  imports = [
    ./files.nix
  ];

  nix = {
    settings = {
      substituters = [
        "https://pvnix.tsrk.me"
      ];
      trusted-public-keys = [
        "pvnix.tsrk.me:gy1cQgGBaAkfWKS1k5sNKwnkg4aOBpcTPOlxj/prlFY="
      ];
    };

    extraOptions = ''
      netrc-file = ${config.age.secrets.netrc.path}
    '';
  };
}
