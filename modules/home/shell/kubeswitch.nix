# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.tsrk.shell.kubeswitch;
in
{
  options = {
    tsrk.shell.kubeswitch = {
      enable = lib.options.mkEnableOption "Kubeswitch shell integration";
      package = lib.options.mkPackageOption pkgs "Kubeswitch" {
        default = [ "kubeswitch" ];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    programs.zsh.initContent = ''
      eval "$(${lib.meta.getExe cfg.package} init zsh)"
      eval "$(${lib.meta.getExe cfg.package} completion zsh)"
    '';

    programs.bash.initExtra = ''
      eval "$(${lib.meta.getExe cfg.package} init bash)"
    '';

    programs.fish.shellInit = ''
      ${lib.meta.getExe cfg.package} init fish | source
    '';
  };
}
