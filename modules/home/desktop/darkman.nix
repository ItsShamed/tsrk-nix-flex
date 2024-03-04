{ config, pkgs, lib, hmLib, ... }:

let
  cfg = config.tsrk.darkman;
  xsettingsd-light = pkgs.writeShellScriptBin "xsettingsd-light" ''
    ${pkgs.gnused}/bin/sed --in-place --follow-symlinks 's/-dark/-light/' "${config.home.homeDirectory}/.xsettingsd"
    ${pkgs.gnused}/bin/sed --in-place --follow-symlinks 's/-Dark/-Light/' "${config.home.homeDirectory}/.xsettingsd"
    ${pkgs.killall}/bin/killall -HUP xsettingsd || true
    ${pkgs.lxappearance}/bin/lxappearance &
    ${pkgs.coreutils}/bin/sleep 1
    ${pkgs.killall}/bin/killall .lxappearance-wrapped
  '';
  xsettingsd-dark = pkgs.writeShellScriptBin "xsettingsd-dark" ''
    ${pkgs.gnused}/bin/sed --in-place --follow-symlinks 's/-light/-dark/' "${config.home.homeDirectory}/.xsettingsd"
    ${pkgs.gnused}/bin/sed --in-place --follow-symlinks 's/-Light/-Dark/' "${config.home.homeDirectory}/.xsettingsd"
    ${pkgs.killall}/bin/killall -HUP xsettingsd || true
    ${pkgs.lxappearance}/bin/lxappearance &
    ${pkgs.coreutils}/bin/sleep 1
    ${pkgs.killall}/bin/killall .lxappearance-wrapped
  '';

  kitty-dark = pkgs.writeShellScript "kitty-dark" ''
    ${pkgs.kitty}/bin/kitty +kitten themes --reload-in=all Tokyo Night
  '';
  kitty-light = pkgs.writeShellScript "kitty-light" ''
    ${pkgs.kitty}/bin/kitty +kitten themes --reload-in=all Tokyo Night Day
  '';
  nvim-dark = pkgs.writeShellScript "nvim-dark" ''
    for server in $(${pkgs.neovim-remote}/bin/nvr --serverlist); do
      ${pkgs.neovim-remote}/bin/nvr --servername "$server" -cc 'colorscheme tokyonight-night'
    done
  '';
  nvim-light = pkgs.writeShellScript "nvim-light" ''
    for server in $(${pkgs.neovim-remote}/bin/nvr --serverlist); do
      ${pkgs.neovim-remote}/bin/nvr --servername "$server" -cc 'colorscheme tokyonight-day'
    done
  '';
  delta-dark = pkgs.writeShellScript "delta-dark" ''
    ${pkgs.gnused}/bin/sed --in-place --follow-symlinks 's/OneHalfLight/OneHalfDark/' "${config.home.homeDirectory}/.gitconfig"
  '';
  delta-light = pkgs.writeShellScript "delta-light" ''
    ${pkgs.gnused}/bin/sed --in-place --follow-symlinks 's/OneHalfDark/OneHalfLight/' "${config.home.homeDirectory}/.gitconfig"
  '';
  bat-dark = pkgs.writeShellScript "bat-dark" ''
    ${pkgs.gnused}/bin/sed --in-place --follow-symlinks 's/OneHalfLight/OneHalfDark/' "${config.xdg.configHome}/bat/config"
  '';
  bat-light = pkgs.writeShellScript "bat-light" ''
    ${pkgs.gnused}/bin/sed --in-place --follow-symlinks 's/OneHalfDark/OneHalfLight/' "${config.xdg.configHome}/bat/config"
  '';

  baseConfig = {
    services.darkman = {
      enable = lib.mkDefault true;
      settings = {
        lng = 48.87951;
        lat = 2.28513;
      };
      lightModeScripts = {
        dunst-notif = ''
          ${pkgs.dunst}/bin/dunstify -a "Darkman - Theme Switching" "Shine bright like a diamond 🌅💎💅"
        '';
      };
      darkModeScripts = {
        dunst-notif = ''
          ${pkgs.dunst}/bin/dunstify -a "Darkman - Theme Switching" "Let tonight's dream begin 🌙✨"
        '';
      };
    };
  };
  xsettingsdLoaded = cfg.xsettingsd.enable && config.tsrk ? xsettingsd.enable && config.tsrk.xsettingsd.enable;
  xsettingsdConfig = {
    services.darkman = {
      lightModeScripts.xsettingsd = ''
        ${pkgs.bash}/bin/bash ${xsettingsd-light}/bin/xsettingsd-light
      '';
      darkModeScripts.xsettingsd = ''
        ${pkgs.bash}/bin/bash ${xsettingsd-dark}/bin/xsettingsd-dark
      '';
    };
  };

  kittyLoaded = cfg.kitty.enable && config.programs.kitty.enable;
  kittyConfig = {
    services.darkman = {
      lightModeScripts.kitty = ''
        ${pkgs.bash}/bin/bash ${kitty-light}
      '';
      darkModeScripts.kitty = ''
        ${pkgs.bash}/bin/bash ${kitty-dark}
      '';
    };
    xdg.configFile."kitty/kitty.conf".target = "kitty/.kitty._hm.conf";

    home.activation.make-kitty-editable = hmLib.dag.entryAfter [ "onFilesChange" ] ''
      _i "Creating editable kitty config"

      function run() {
        if [[ -v VERBOSE ]]; then
          echo $@
        else
          $@
        fi
      }

      run cp -f ${config.xdg.configHome}/kitty/.kitty._hm.conf ${config.xdg.configHome}/kitty/kitty.conf

      unset -f run
    '';
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
        ${pkgs.feh}/bin/feh --bg-scale ${cfg.feh.light}
      '';
      darkModeScripts.feh = ''
        ${pkgs.feh}/bin/feh --bg-scale ${cfg.feh.dark}
      '';
    };
  };

  deltaLoaded = cfg.delta.enable && config.programs.git.delta.enable;
  deltaConfig = {
    services.darkman = {
      lightModeScripts.delta= ''
        ${pkgs.bash}/bin/bash ${delta-light}
      '';
      darkModeScripts.delta = ''
        ${pkgs.bash}/bin/bash ${delta-dark}
      '';
    };
  };

  batLoaded = cfg.bat.enable && config.programs.kitty.enable;
  batConfig = {
    services.darkman = {
      lightModeScripts.kitty = ''
        ${pkgs.bash}/bin/bash ${kitty-light}
      '';
      darkModeScripts.kitty = ''
        ${pkgs.bash}/bin/bash ${kitty-dark}
      '';
    };
    xdg.configFile."bat/config".target = "bat/._hm.config";

    home.activation.make-bat-editable = hmLib.dag.entryAfter [ "onFilesChange" ] ''
      _i "Creating editable bat config"

      function run() {
        if [[ -v VERBOSE ]]; then
          echo $@
        else
          $@
        fi
      }

      run cp -f ${config.xdg.configHome}/bat/._hm.config ${config.xdg.configHome}/bat/config

      unset -f run
    '';
  };
in
{
  options = {
    tsrk.darkman = {
      enable = lib.options.mkEnableOption "darkman";
      xsettingsd.enable = lib.options.mkEnableOption "theme switching for xsettingsd";
      kitty.enable = lib.options.mkEnableOption "theme switching for kitty";
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
      delta.enable = lib.options.mkEnableOption "theme switching for delta";
      bat.enable = lib.options.mkEnableOption "theme switching for bat";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    baseConfig
    (lib.mkIf xsettingsdLoaded xsettingsdConfig)
    (lib.mkIf kittyLoaded kittyConfig)
    (lib.mkIf nvimLoaded nvimConfig)
    (lib.mkIf fehLoaded fehConfig)
    (lib.mkIf deltaLoaded deltaConfig)
    (lib.mkIf batLoaded batConfig)
  ]);
}
