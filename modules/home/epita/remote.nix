# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{
  config,
  lib,
  pkgs,
  ...
}:

let
  literalBool = predicate: if predicate then "true" else "false";
  cfg = config.tsrk.epita.remoteWork;
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
    git config user.name ${gitCfg.settings.user.name}
    git config user.email ${gitCfg.settings.user.email}
    git config commit.gpgsign ${literalBool gitCfg.signing.signByDefault}
    ${lib.strings.optionalString (gitCfg.signing.signByDefault) "git config user.signingKey ${gitCfg.signing.key}"}
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
      home.packages = [
        gitSwitchNormal
        gitSwitchSchool
      ];
      programs.ssh = {
        matchBlocks = {
          "ssh.cri.epita.fr" = {
            extraOptions = {
              "GSSAPIAuthentication" = "yes";
              "GSSAPIDelegateCredentials" = "yes";
            };
          };
        };
      };

      warnings =
        if (lib.strings.stringLength cfg.fullName) > 80 then
          [
            "You full name is over 80 characters, which will violate the nettiquete if included in the signature."
          ]
        else
          [ ];

      assertions = [
        {
          assertion = (lib.strings.stringLength cfg.signature.status) <= 80;
          message = "E-mail signature status is too long (${cfg.signature.status} > 80) and would violate the netiquette.";
        }
        {
          assertion = (lib.strings.stringLength cfg.signature.quote) <= 76;
          message = "E-mail signature quote is too long (${cfg.signature.quote} > 76) and would violate the netiquette.";
        }
      ];
      accounts.email.accounts.epita = rec {
        address = "${cfg.login}@epita.fr";
        userName = address;
        realName = cfg.fullName;
        flavor = "outlook.office365.com";
        signature = {
          showSignature = "append";
          delimiter = "-- ";
          text = ''
            ${cfg.fullName}
            ${cfg.signature.status}
            « ${cfg.signature.quote} »
          '';
        };
        thunderbird = {
          enable = true;
          settings = id: {
            # Even though the flavour does a lot of work for us, it does not
            # enforce OAuth2 authentication for the SMTP server, and there is
            # no option to configure that yet (as of 2024-07-16)
            # Relevant issues:
            #   https://github.com/nix-community/home-manager/issues/5137
            #   https://github.com/nix-community/home-manager/issues/4988
            "mail.server.server_${id}.authMethod" = 10;
            "mail.smtpserver.smtp_${id}.authMethod" = 10;
            "mail.smtpserver.smtp_${id}.oauth2.issuer" = "login.microsoftonline.com";
          };
        };
      };
    })
  ];
}
