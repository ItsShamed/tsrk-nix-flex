{ lib, config, ... }:

let
  cfg = config.tsrk.shell;
  posixInitExtra = lib.strings.concatLines [
    ''
      export GPG_TTY=$(tty)
    ''
  ];
in
{
  options = {
    tsrk.shell = {
      initExtra = lib.options.mkOption {
        description = "Common extra shell-agnostic initialisation script";
        type = lib.types.lines;
        default = "";
      };
      enableViKeybinds = lib.options.mkEnableOption "vi-like keybinds";
    };
  };

  imports = [
    ./bat.nix
    ./bash.nix
    ./fastfetch.nix
    ./lsd.nix
    ./starship.nix
    ./zoxide.nix
    ./zsh.nix
  ];

  config = {
    programs.bash.initExtra = lib.strings.concatLines [
      (lib.strings.optionalString cfg.enableViKeybinds ''
        set -o vi
      '')
      posixInitExtra
      cfg.initExtra
    ];
    programs.zsh.initExtra = lib.strings.concatLines [
      posixInitExtra
      cfg.initExtra
    ];
    programs.fish.shellInit = lib.strings.concatLines [
      (lib.strings.optionalString cfg.enableViKeybinds ''
        fish_vi_key_bindings
      '')
      cfg.initExtra
    ];

    programs.zsh = {
      defaultKeymap = lib.mkIf cfg.enableViKeybinds "viins";
    };
  };
}
