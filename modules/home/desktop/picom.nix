{ self, ... }:

{ config, lib, pkgs, ... }:

let
  baseConfig = {
    services.picom = {
      enable = true;
      fade = true;
      extraArgs = [ "--no-use-damage" ];
      backend = "glx";
      fadeDelta = 5;
      fadeSteps = [ 0.075 0.030 ];
      opacityRules = [
        "100:class_g = 'kitty' && focused"
        "75:class_g = 'kitty' && !focused"
      ];
      shadow = true;
      shadowExclude = [
        "class_g = 'Dunst'"
      ];
      # TODO: Looking forward to put back animations when the new picom with
      # animations get pacakged for nixpkgs
    };
  };

  picomCfg = config.services.picom;

  compatConfig = {
    systemd.user.services.picom.Service.ExecStart = lib.mkForce (
      self.lib.mkGL pkgs config (lib.strings.concatStringsSep " " ([
        "${lib.meta.getExe picomCfg.package}"
        "--config ${config.xdg.configFile."picom/picom.conf".source}"
      ] ++ picomCfg.extraArgs)
      )
    );
  };
in
{
  options = {
    tsrk.picom.enable = lib.options.mkEnableOption "tsrk's Picom configuration";
  };

  config = lib.mkIf config.tsrk.picom.enable (lib.mkMerge [
    baseConfig
    compatConfig
  ]);
}
