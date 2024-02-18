{ config, pkgs, lib, hmLib, ... }:

let
  cfg = config.tsrk.xsettingsd;
  renderSettings = settings:
    lib.concatStrings (lib.mapAttrsToList renderSetting settings);

  renderSetting = key: value: ''
    ${key} ${renderValue value}
  '';

  renderValue = value:
    {
      int = toString value;
      bool = if value then "1" else "0";
      string = ''"${value}"'';
    }.${builtins.typeOf value};

  xsettingsdConf = pkgs.writeText "xsettingsd.conf" (renderSettings cfg.settings);
in
{
  options = {
    tsrk.xsettingsd = {
      enable = lib.options.mkEnableOption "xsettingsd";
      settings = lib.options.mkOption {
        type = with lib.types; attrsOf (oneOf [ bool int str ]);
        default = {
          "Net/ThemeName" = "vimix-light-doder";
          "Xft/Antialias" = 1;
          "Xft/HintStyle" = "hintfull";
          "Xft/Hinting" = 1;
          "Xft/RGBA" = "rgb";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.xsettingsd.enable = lib.mkDefault true;

    home.activation.xsettingsd-base-configuration = hmLib.dag.entryBefore [ "reloadSystemd" ] ''
      if [[ -v VERBOSE ]]; then
        echo Creating xsettingsd base configuration
      fi
      test -f "${config.home.homeDirectory}/.xsettingsd" || cp -f "${xsettingsdConf}" "${config.home.homeDirectory}/.xsettingsd"
    '';
  };
}
