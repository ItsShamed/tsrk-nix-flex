# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

args:

{ lib, pkgs, ... }:

{
  imports = [
    ./keymaps.nix
    ./options.nix
    (lib.modules.importApply ./plugins args)
  ];

  clipboard.register = "unnamedplus";
  clipboard.providers = {
    wl-copy.enable = pkgs.stdenv.hostPlatform.isLinux;
    xclip.enable = pkgs.stdenv.hostPlatform.isLinux;
    xsel.enable = pkgs.stdenv.hostPlatform.isLinux;
    pbcopy.enable = pkgs.stdenv.hostPlatform.isDarwin;
  };

  colorschemes.tokyonight.enable = true;
  colorscheme = "tokyonight-storm";

  files = {
    "ftplugin/nix.lua" = {
      opts = {
        expandtab = true;
        shiftwidth = 2;
        tabstop = 2;
        softtabstop = 2;
      };
    };
  };

  extraConfigVim = ''
      augroup highlight_yank
      autocmd!
      au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
    augroup END
  '';
}
