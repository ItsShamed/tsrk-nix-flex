# Copyright (c) 2024 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ lib, config, ... }:

{
  options = {
    tsrk.shell.bash = {
      enable = lib.options.mkEnableOption "tsrk's bash configuration";
    };
  };

  config = lib.mkIf config.tsrk.shell.bash.enable {
    programs.bash = {
      enable = true;
      enableCompletion = true;
    };
  };
}
