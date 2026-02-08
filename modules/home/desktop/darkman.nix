# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.tsrk.darkman;

  # TODO: Changing themes via NeoVim sockets the old-fashioned way is the most
  # reasonnable thing to do for now, until me or someone is brave enough to
  # package this hell https://github.com/4e554c4c/darkman.nvim...

  nvim-dark = pkgs.writeShellScript "nvim-dark" ''
    for server in $(${pkgs.neovim-remote}/bin/nvr --serverlist); do
      ${pkgs.neovim-remote}/bin/nvr --servername "$server" -cc 'colorscheme tokyonight-storm'
    done
  '';
  nvim-light = pkgs.writeShellScript "nvim-light" ''
    for server in $(${pkgs.neovim-remote}/bin/nvr --serverlist); do
      ${pkgs.neovim-remote}/bin/nvr --servername "$server" -cc 'colorscheme tokyonight-day'
    done
  '';

  baseConfig = {
    services.darkman = {
      enable = lib.mkDefault true;
      package = pkgs.darkman;
      settings = {
        lat = 48.87951;
        lng = 2.28513;
      };
      lightModeScripts = {
        notif = ''
          ${pkgs.libnotify}/bin/notify-send -a "Darkman" "Theme Switching" "Shine bright like a diamond 🌅💎💅"
        '';
        activate-home-manager = ''
          export PATH="/nix/var/nix/profiles/default/bin:$PATH"
          . ${config.home.homeDirectory}/.local/bin/hm-light-activate
        '';
      };
      darkModeScripts = {
        notif = ''
          ${pkgs.libnotify}/bin/notify-send -a "Darkman" "Theme Switching" "Let tonight's dream begin 🌙✨"
        '';
        activate-home-manager = ''
          export PATH="/nix/var/nix/profiles/default/bin:$PATH"
          . ${config.home.homeDirectory}/.local/bin/hm-dark-activate
        '';
      };
    };

    xdg.portal = lib.mkIf cfg.installPortal {
      extraPortals = [ config.services.darkman.package ];
      config.common = {
        "org.freedesktop.impl.portal.Settings" = "darkman";
      };
    };

    home.activation.copy-activation = lib.hm.dag.entryAfter [ "reloadSystemd" ] ''
      echo "Copying activation scripts"
      activation_dir="$(dirname -- "''${BASH_SOURCE[0]}")"
      activation_dir="$(cd -- "$activation_dir" && pwd)"
      base_dir="$(basename "$activation_dir")"
      if [ -z "$base_dir" ] || ! [ -e "$activation_dir/specialisation/light/activate" ] || ! [ -e "$activation_dir/specialisation/dark/activate" ]; then
        warnEcho "Running in improper directory for linking activation scripts."
        noteEcho "If you are running the theme switching activation script (e.g. via darkman) you can ignore this."
      else
        local_bin_path="${config.home.homeDirectory}/.local/bin"
        run mkdir -p "$local_bin_path"
        run ln -sf $activation_dir/specialisation/light/activate "$local_bin_path"/hm-light-activate 2>/dev/null || true
        run ln -sf $activation_dir/specialisation/dark/activate "$local_bin_path"/hm-dark-activate 2>/dev/null || true
      fi

      unset activation_dir base_dir
    '';

    home.packages = with pkgs; [
      (writeShellScriptBin "hm-switch" ''
        cd $HOME/.config/home-manager
        home-manager build $@
        . result/specialisation/$(${pkgs.darkman}/bin/darkman get)/activate
      '')
    ];

    home.sessionPath = [ "$HOME/.local/bin" ];
  };

  nvimLoaded = cfg.nvim.enable;
  nvimConfig = {
    services.darkman = {
      lightModeScripts.nvim = ''
        ${pkgs.bash}/bin/bash ${nvim-light}
      '';
      darkModeScripts.nvim = ''
        ${pkgs.bash}/bin/bash ${nvim-dark}
      '';
    };
  };

  fehLoaded = cfg.feh.enable;
  fehConfig = {
    services.darkman = {
      lightModeScripts.feh = ''
        if [ "''${XDG_SESSION_TYPE:-}" = "x11" ] && [ -z "''${WAYLAND_DISPLAY:-}" ]; then
          ${pkgs.feh}/bin/feh --bg-fill ${cfg.feh.light}
        else
          echo "Not running X11, skipping feh" >&2
        fi
      '';
      darkModeScripts.feh = ''
        if [ "''${XDG_SESSION_TYPE:-}" = "x11" ] && [ -z "''${WAYLAND_DISPLAY:-}" ]; then
          ${pkgs.feh}/bin/feh --bg-fill ${cfg.feh.dark}
        else
          echo "Not running X11, skipping feh" >&2
        fi
      '';
    };
  };
in
{
  options = {
    tsrk.darkman = {
      enable = lib.options.mkEnableOption "darkman";
      installPortal = lib.options.mkOption {
        type = lib.types.bool;
        description = "Whether to install darkman as a Settings portal";
        default = false;
      };
      nvim.enable = lib.options.mkEnableOption "theme switching for NeoVim";
      feh = {
        enable = lib.options.mkEnableOption "background switching with feh";
        light = lib.options.mkOption {
          type = lib.types.path;
          description = "Path to the light-themed background.";
          default = ./files/torekka.png;
        };
        dark = lib.options.mkOption {
          type = lib.types.path;
          description = "Path to the dark-themed background.";
          default = ./files/bg-no-logo.png;
        };
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      baseConfig
      (lib.mkIf nvimLoaded nvimConfig)
      (lib.mkIf fehLoaded fehConfig)
    ]
  );
}
