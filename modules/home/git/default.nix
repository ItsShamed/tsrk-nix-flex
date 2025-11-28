# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

args:

{ config, lib, ... }:

{
  imports = [
    ./cli.nix
    (lib.modules.importApply ./delta.nix args)
    (lib.modules.importApply ./lazygit.nix args)
  ];

  options = {
    tsrk.git.enable = lib.options.mkEnableOption "tsrk's Git configuration";
  };

  config = lib.mkIf config.tsrk.git.enable {
    warnings = (
      lib.mkIf (config.programs.git.settings.user.email or null == null) [
        ''
          You didn't set an e-mail in your Git config. If it is intended, don't
          forget to set it manually afterwards. Otherwise, you won't be able to
          use Git.
        ''
      ]
    );
    programs.git = {
      enable = true;
      lfs.enable = lib.mkDefault true;
      settings = {
        user.name = lib.mkDefault "${config.home.username}";
        init.defaultBranch = "main";
      };
    };
  };
}
