{ config, lib, ... }:

{
  options = {
    tsrk.hyprland.enable = lib.options.mkEnableOption "Hyprland as a window manager";
  }

  config = lib.mkIf config.tsrk.hyprland.enable {
    programs.hyprland.enable = true;
  }
}
