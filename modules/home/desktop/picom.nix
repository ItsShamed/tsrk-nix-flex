# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, ... }:

{ config, lib, ... }:

let
  baseConfig = {
    # TODO: Maybe reinstate module definition when HM will support specifying
    # libconfig lists (not arrays), which is required to define animations
    # See: https://github.com/nix-community/home-manager/issues/5744
    services.picom = {
      enable = true;
      # fade = true;
      # backend = "glx";
      # fadeDelta = 5;
      # fadeSteps = [ 0.075 0.030 ];
      # opacityRules = [
      #   "100:class_g = 'kitty' && focused"
      #   "75:class_g = 'kitty' && !focused"
      # ];
      # shadow = true;
      # shadowExclude = [
      #   "class_g = 'Dunst'"
      #   "class_g = 'Screenkey'"
      #   "class_g = 'screenkey'"
      # ];
    };
    xdg.configFile."picom/picom.conf" = {
      source = ./files/picom.conf;
      text = lib.mkForce null;
    };

    warnings = [
      "tsrk: Picom has been configured with a hard-coded file, completely discarding any configuration made from the Home-Manager module."
    ];
  };

  picomCfg = config.services.picom;

  compatConfig = {
    systemd.user.services.picom.Service.ExecStart = lib.mkForce (
      self.lib.mkGL config (
        lib.strings.concatStringsSep " " (
          [
            "${lib.meta.getExe picomCfg.package}"
            "--config ${config.xdg.configFile."picom/picom.conf".source}"
          ]
          ++ picomCfg.extraArgs
        )
      )
    );
  };
in
{
  options = {
    tsrk.picom.enable = lib.options.mkEnableOption "tsrk's Picom configuration";
  };

  config = lib.mkIf config.tsrk.picom.enable (
    lib.mkMerge [
      baseConfig
      compatConfig
    ]
  );
}
