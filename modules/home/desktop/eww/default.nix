# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ pkgs, lib, config, ... }:

let
  binDeps =
    lib.makeBinPath (with pkgs; [ imagemagick playerctl util-linux gawk ]);
  packagedDir = pkgs.stdenv.mkDerivation {
    pname = "tsrk-eww-config";
    version = "0.0.1";
    src = ./.;

    nativeBuildInputs = with pkgs; [ makeWrapper ];

    installPhase = ''
      mkdir -p $out
      cp -r * $out

      for script in $(find $out/scripts -type f ! -name '*.sh'); do
          wrapProgram $script --prefix PATH : ${binDeps}
      done
    '';

    dontBuild = true;
    dontConfigure = true;
    dontPatch = true;

    meta = with lib; {
      license = licenses.mit;
      platforms = platforms.linux;
    };
  };

  ewwMprisWatcherScript = pkgs.writeShellScriptBin "eww-mpris-watcher" ''
    set -euo pipefail

    graceful_exit() {
        ${config.programs.eww.package}/bin/eww --no-daemonize close bottom-dock
        trap - SIGTERM SIGINT
        exit 0
    }

    trap graceful_exit SIGTERM SIGINT

    while read -r status; do
        if [ -z "$status" ]; then
            ${config.programs.eww.package}/bin/eww --no-daemonize close bottom-dock
            continue
        fi

        if ! (${config.programs.eww.package}/bin/eww --no-daemonize active-windows | grep bottom-dock); then
            ${config.programs.eww.package}/bin/eww --no-daemonize open bottom-dock
        fi
    done < <(${pkgs.playerctl}/bin/playerctl --follow status)
  '';
in {
  options = {
    tsrk.eww = {
      enable = lib.options.mkEnableOption "tsrk's eww configuration bundle";
    };
  };

  config = lib.mkIf config.tsrk.eww.enable {
    programs.eww = {
      enable = lib.mkDefault true;
      configDir = lib.mkDefault packagedDir;
    };

    systemd.user.services = {
      eww = {
        Unit = {
          Description = "Elkowar's Wacky Widgets daemon";
          Documentation = "https://elkowar.github.io/eww/eww.html";
          PartOf = "graphical-session.target";
        };

        Install.WantedBy = [ "graphical-session.target" ];

        Service = {
          Type = "exec";
          ExecStart =
            "${config.programs.eww.package}/bin/eww --no-daemonize daemon";
          Restart = "on-failure";
        };
      };

      eww-mpris-watcher = {
        Unit = {
          Description = "Elkowar's Wacky Widgets daemon";
          Documentation = "https://elkowar.github.io/eww/eww.html";
          Requires = "eww.service";
          After = "eww.service";
        };

        Install.WantedBy = [ "graphical-session.target" ];

        Service = {
          Type = "exec";
          ExecStart = "${ewwMprisWatcherScript}/bin/eww-mpris-watcher";
        };
      };

    };
  };
}
