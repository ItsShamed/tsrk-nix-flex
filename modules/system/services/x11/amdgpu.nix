{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.tsrk.x11.amdgpu;
  renderOption =
    optionName: value:
    let
      confValue =
        if builtins.isBool value then
          if value then "on" else "off"
        else
          builtins.toString value;
    in
    if builtins.isNull value then
      "        # Option \"${optionName}\" is left out"
    else
      "        Option \"${optionName}\" \"${confValue}\"";

  confOptions = {
    SWCursor = cfg.softwareCursor;
    Accel = cfg.hardwareAcceleration.enable;
    ZaphodHeads =
      if builtins.isList cfg.zaphodHeads then
        lib.strings.concatStringsSep "," cfg.zaphodHeads
      else
        cfg.zaphodHeads;
    DRI = cfg.maximumDRILevel;
    EnablePageFlip = cfg.pageFlip;
    TearFree = cfg.tearFree;
    VariableRefresh = cfg.freeSync;
    AsyncFlipSecondaries = cfg.asyncFlips;
    AccelMethod = cfg.hardwareAcceleration.method;
  }
  // cfg.extraConfig;

  optionStrings = lib.attrsets.mapAttrsToList renderOption confOptions;
in
{
  options = {
    tsrk.x11.amdgpu = {
      enable = lib.options.mkEnableOption "X11 config for AMD GPUs";
      extraConfig = lib.options.mkOption {
        type =
          with lib.types;
          attrsOf (oneOf [
            number
            bool
            str
          ]);
        description = ''
          Additionnal options to set for the amdgpu Xorg Device. Please refer to
          amdgpu(4) for available options to set.
        '';
        default = { };
      };
      softwareCursor = lib.options.mkEnableOption "software cursor selection";
      hardwareAcceleration = {
        enable = lib.options.mkEnableOption "hardware acceleration" // {
          default = true;
        };
        method = lib.options.mkOption {
          type =
            with lib.types;
            enum [
              "none"
              "glamor"
            ];
          description = "Hardware acceleration architecture to use.";
          default = "glamor";
        };
      };
      zaphodHeads = lib.options.mkOption {
        type = with lib.types; nullOr (either (listOf str) str);
        description = "RandR output(s) to use with zaphod mode.";
        default = null;
      };
      maximumDRILevel = lib.options.mkOption {
        type =
          with lib.types;
          enum [
            2
            3
          ];
        description = "The maximum DRI Level to enable.";
        defaultText = "3 if Xorg Server version is >= 18.3, else 2";
        default =
          if (lib.versionAtLeast pkgs.xorg.xorgserver.version "18.3") then 3 else 2;
      };
      pageFlip = lib.options.mkEnableOption "DRI2 page flipping" // {
        default = true;
      };
      tearFree = lib.options.mkOption {
        type = with lib.types; nullOr bool;
        description = ''
          Whether to enable tearing prevention.

          If `null`, tearing prevention will be enabled for rotated outputs,
          outputs with RandR transforms, and RandR 1.4 secondary outputs;
          otherwise it is turned off.
        '';
        default = null;
      };
      freeSync = lib.options.mkEnableOption "AMD FreeSync";
      asyncFlips = lib.options.mkEnableOption "async flips for secondary video outputs";
    };
  };

  config = lib.mkIf cfg.enable {

    services.xserver.videoDrivers = lib.mkDefault (lib.mkBefore [ "amdgpu" ]);

    environment.etc = {
      "X11/xorg.conf.d/20-amdgpu.conf" = {
        text = ''
          Section "OutputClass"
                  Identifier  "AMD"
                  MatchDriver "amdgpu"
                  Driver      "amdgpu"

          ${lib.strings.concatStringsSep "\n" optionStrings}
          EndSection
        '';
      };
    };
  };
}
