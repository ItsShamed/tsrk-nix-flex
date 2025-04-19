# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ lib, ... }:

{
  warnings = [
    "markdown-preview browser is set to 'librewolf', if it's not what you want, please change `plugins.markdown-preview.settings.browser`"
  ];
  plugins.markdown-preview = {
    enable = true;
    settings.browser = lib.mkDefault "librewolf";
  };
}
