# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  plugins.none-ls = {
    enable = true;
    sources = {
      diagnostics = {
        deadnix.enable = true;
        kube_linter.enable = true;
        markdownlint.enable = true;
        opentofu_validate = {
          enable = true;
          settings.extra_filetypes = [ "tfvars" ];
        };
      };
      formatting = {
        markdownlint.enable = true;
        shfmt.enable = true;
      };
    };
  };
}
