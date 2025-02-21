# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ config, lib, ... }:

{
  options = {
    tsrk.redshift = { enable = lib.options.mkEnableOption "redshift"; };
  };

  # Derived from
  # https://gitlab.cri.epita.fr/cri/infrastructure/nixpie/-/blob/master/modules/services/x11/redshift.nix
  config = lib.mkIf config.tsrk.redshift.enable {
    services.redshift = {
      enable = true;
      temperature.night = 3000;
      brightness.night = "0.85";
    };

    # Used by redshift to determine sunrise and sunset.
    location = {
      latitude = 48.87951;
      longitude = 2.28513;
    };
  };
}
