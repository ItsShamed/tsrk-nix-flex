# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

args:

{ lib, config, ... }:

let
  cfg = config.tsrk.shell;
  posixInitExtra = lib.strings.concatLines [''
    export GPG_TTY=$(tty)
  ''];
in {
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
    (lib.modules.importApply ./bat.nix args)
    ./bash.nix
    ./direnv.nix
    ./fastfetch.nix
    ./kubeswitch.nix
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
    programs.zsh.initContent =
      lib.strings.concatLines [ posixInitExtra cfg.initExtra ];
    programs.fish.shellInit = lib.strings.concatLines [
      (lib.strings.optionalString cfg.enableViKeybinds ''
        fish_vi_key_bindings
      '')
      cfg.initExtra
    ];

    programs.zsh = { defaultKeymap = lib.mkIf cfg.enableViKeybinds "viins"; };
  };
}
