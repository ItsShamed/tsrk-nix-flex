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

  baseConfig = 
  {
    services.darkman = {
      enable = lib.mkDefault true;
      settings = {
        lng = 48.87951;
        lat = 2.28513;
      };
      lightModeScripts = {
        dunst-notif = ''
          ${pkgs.dunst}/bin/dunstify -a "Darkman" "Theme Switching" "Shine bright like a diamond 🌅💎💅"
        '';
        activate-home-manager = ''
          export PATH="/nix/var/nix/profiles/default/bin:$PATH"
          . ${config.xdg.configHome}/home-manager/result/specialisation/light/activate
        '';
      };
      darkModeScripts = {
        dunst-notif = ''
          ${pkgs.dunst}/bin/dunstify -a "Darkman" "Theme Switching" "Let tonight's dream begin 🌙✨"
        '';
        activate-home-manager = ''
          export PATH="/nix/var/nix/profiles/default/bin:$PATH"
          . ${config.xdg.configHome}/home-manager/result/specialisation/dark/activate
        '';
      };
    };

    home.packages = with pkgs; [
      (writeShellScriptBin "hm-switch" ''
        cd $HOME/.config/home-manager
        home-manager build $@
        . result/specialisation/$(${pkgs.darkman}/bin/darkman get)/activate
      '')
    ];
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
in
{
  options = {
    tsrk.darkman = {
      enable = lib.options.mkEnableOption "darkman";
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

  config = lib.mkIf cfg.enable (lib.mkMerge [
    baseConfig
    (lib.mkIf nvimLoaded nvimConfig)
    (lib.mkIf fehLoaded fehConfig)
  ]);
}
