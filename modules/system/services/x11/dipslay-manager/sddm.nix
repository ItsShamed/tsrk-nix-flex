# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, inputs, ... }:

{ config, lib, pkgs, ... }:

let
  cfg = config.tsrk.sddm;
  tsrkPkgs = self.packages.${pkgs.system};
  babysitter = pkgs.writeShellApplication {
    name = "sddm-babysitter";
    runtimeInputs = with pkgs; [ procps ];

    text = ''
      echo "Ready to babysit SDDM!"
      strace_args='-e trace=none -e signal=none -q'

      while true; do
        sleep 2
        if ! sddm_pid="$(pgrep '^(sddm)$')"; then
          echo "SDDM is no longer running, exiting…" >&2
          break
        fi

        while ! helper_pid=$(pgrep -P "$sddm_pid" '^(sddm-helper)$'); do
          echo "Searching for helper process…" >&2
          sleep 1
        done

        echo "Watching helper process with pid $helper_pid…"
        # shellcheck disable=SC2086
        if strace $strace_args -p "$helper_pid" |& grep ' 0 '; then
          echo "Helper exited normally! (OK)"
          continue
        fi

        echo "Oh no, SDDM Helper crashed! SDDM will be crying!"
        echo "Killing X server to babysit it!!!"
        pkill -P "$sddm_pid" X
      done
    '';
  };
in {
  imports = [ inputs.sddm-babysitter.nixosModules.default ];

  options = {
    tsrk.sddm = {
      enable = lib.options.mkEnableOption "sddm as a display manager";
      babysit = lib.options.mkEnableOption
        "babysitting SDDM if its helper ever crashes";
    };
  };

  config = lib.mkIf cfg.enable {
    services.displayManager.sddm = {
      enable = true;
      autoNumlock = true;
      theme = "slice";
    };

    services.sddm-babysitter.enable = lib.mkDefault cfg.babysit;

    # systemd.services.sddm-babysitter = {
    #   enable = lib.mkDefault cfg.babysit;
    #   description = "Daemon to babysit SDDM";
    #
    #   wantedBy = [ "multi-user.target" ];
    #   after = [ "display-manager.service" ];
    #
    #   serviceConfig = {
    #     ExecStart = "${babysitter}/bin/sddm-babysitter";
    #     Type = "exec";
    #     Restart = "on-failure";
    #   };
    # };

    environment.systemPackages = [
      (tsrkPkgs.sddm-slice-theme.withConfig {
        color_bg = "#24283b";
        color_contrast = "#1f2335";
        color_dimmed = "#a9b1d6";
        color_main = "#c0caf5";
      })
    ];
  };
}
