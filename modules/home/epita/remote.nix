{ config, lib, pkgs, ... }:

let
  cfg = config.tsrk.epita.remoteWork;
  emailCfg = config.accounts.email;
  gitCfg = config.programs.git;
  gitSwitchSchool = pkgs.writeShellScriptBin "git-switch-school" ''
    set -x
    git config user.name "${cfg.fullName}"
    git config user.email ${cfg.login}@epita.fr
    ${lib.strings.optionalString (cfg.gpgKey != null) ''
      git config commit.gpgsign true
      git config user.signingKey ${cfg.gpgKey}
    ''}
    set +x
  '';

  gitSwitchNormal = pkgs.writeShellScriptBin "git-switch-normal" ''
    set -x
    git config user.name ${gitCfg.userName}
    git config user.email ${gitCfg.userEmail}
    git config commit.gpgsign ${gitCfg.signing.signByDefault}
    git config user.signingKey ${gitCfg.signing.key}
    set +x
  '';
in
{
  options = {
    tsrk.epita.remoteWork = {
      enable = lib.options.mkEnableOption "EPITA remote work environment";
      login = lib.options.mkOption {
        type = lib.types.str;
        description = "Your EPITA login.";
        default = "xavier.login";
        example = "xavier.login";
      };
      fullName = lib.options.mkOption {
        type = lib.types.str;
        description = "Your full name.";
        default = "Xavier Login";
        example = "Xavier Login";
      };
      gpgKey = lib.options.mkOption {
        type = lib.types.nullOr lib.types.str;
        description = "The GPG Key that will be used to sign commits and e-mails";
        default = null;
      };
      signature = {
        status = lib.mkOption {
          type = lib.types.str;
          description = "Signature line describing your current state in the school.";
          default = "XXX - 20XX (seriously please put something here)";
          example = "ING1 - 2026";
        };
        quote = lib.mkOption {
          type = lib.types.str;
          description = "A fun quote to include in your emails (EPITA only).";
          default = "I am a NPC, I didn't change the quote from the config I stole.";
          example = "I want to break free(1)";
        };
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home.packages = with pkgs; [
        gitSwitchNormal
        gitSwitchSchool
      ];
      assertions = [
        {
          assertion = (lib.strings.stringLength cfg.signature.status) <= 78;
          message = "E-mail signature status is too long (${cfg.signature.status} > 80) and would violate the netiquette.";
        }
        {
          assertion = (lib.strings.stringLength cfg.signature.quote) <= 78;
          message = "E-mail signature quote is too long (${cfg.signature.quote} > 78) and would violate the netiquette.";
        }
      ];
      accounts.email.accounts.epita = rec {
        address = "${cfg.login}@epita.fr";
        userName = address;
        imap.host = "outlook.office365.com";
        signature = {
          text = ''
            ${cfg.signature.status}
            "${cfg.signature.quote}"
          '';
        };
        thunderbird.enable = true;
      };
    })
  ];
}
