{ config, lib, pkgs, ... }:

let
  usersList = lib.attrsets.attrsToList config.users.users;
  isSingleUserSystem = lib.lists.count (v: v.value.isNormalUser) usersList <= 1;
in {
  options = {
    tsrk.earlyoom = {
      enable = lib.options.mkEnableOption "tsrk's EarlyOOM configuration";
    };
  };

  config = lib.mkIf config.tsrk.earlyoom.enable {
    services.earlyoom = {
      enable = true;
      enableNotifications = lib.mkDefault isSingleUserSystem;
      killHook = pkgs.writeShellScript "earlyoom-kill-hook" ''
        ${pkgs.ffmpeg}/bin/ffplay ${./oomf.mp3} -autoexit -nodisp
      '';
    };

    services.systembus-notify.enable = lib.mkDefault isSingleUserSystem;
  };
}
