# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ ... }:

{
  plugins.markview = {
    enable = true;
    luaConfig.pre = ''
      local presets = require("markview.presets");
    '';
    settings = {
      preview = {
        hybrid_modes = [ "n" ];
        icon_provider = "devicons";
      };
      html = {
        enable = true;
        tags.enable = true;
      };
      markdown = {
        headings = {
          setext_1.style = "decorated";
          setext_2.style = "decorated";
        };
      };
      typst = {
        code_blocks.enable = false;
      };
      markdown_inline = {
        enable = true;
        checkboxes.__raw = "presets.checkboxes.nerd";
        inline_codes.enable = true;
        hyperlinks.enable = true;
        images.enable = true;
        emails.enable = true;
        internal_links.enable = true;
      };
    };
  };
}
