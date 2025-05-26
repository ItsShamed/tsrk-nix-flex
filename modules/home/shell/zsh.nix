# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ lib, config, ... }:

{
  options = {
    tsrk.shell.zsh = {
      enable = lib.options.mkEnableOption "tsrk's zsh configuration";
    };
  };

  config = lib.mkIf config.tsrk.shell.zsh.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      historySubstringSearch.enable = true;
      autocd = true;
      initContent = ''
        bindkey '^R' history-incremental-search-backward
      '';
    };
  };
}
