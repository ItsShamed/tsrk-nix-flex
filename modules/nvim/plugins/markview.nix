# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
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
      preview.hybrid_modes = [ "n" ];
      checkboxes.__raw = "presets.checkboxes.nerd";
      headings = {
        setext_1 = {
          style = "decorated";
        };
        setext_2 = {
          style = "decorated";
        };
      };
      html = {
        enable = true;
        tags.enable = true;
      };
      inline_codes.enable = true;
      links = {
        enable = true;
        hyperlinks.enable = true;
        images.enable = true;
        emails.enable = true;
        internal_links.enable = true;
      };
    };
  };
}
