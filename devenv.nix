{ pkgs, inputs, ... }:

{
  languages.nix.enable = true;

  packages = with pkgs; [
    nix-output-monitor
    inputs.agenix.packages.${pkgs.system}.default
  ];

  git-hooks = {
    hooks = {
      deadnix = {
        enable = true;
        settings = {
          edit = true;
          noLambdaArg = true;
        };
      };
      nixfmt-classic = {
        enable = true;
        settings = { width = 80; };
      };
    };
  };
}
