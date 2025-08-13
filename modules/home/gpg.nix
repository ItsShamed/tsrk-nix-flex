# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ config, lib, ... }:

let cfg = config.tsrk.gpg;
in {
  options = {
    tsrk.gpg = {
      enable = lib.options.mkEnableOption "tsrk's GPG configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.gpg = {
      enable = lib.mkDefault true;
      # Settings are taken from https://github.com/drduh/YubiKey-Guide/blob/master/config/gpg.conf
      scdaemonSettings.disable-ccid = true;
      settings = {
        keyserver = "keys.openpgp.org";
        personal-cipher-preferences = [ "AES256" "AES192" "AES" ];
        personal-digest-preferences = [ "SHA512" "SHA384" "SHA256" ];
        personal-compress-preferences = [ "ZLIB" "BZIP2" "ZIP" "Uncompressed" ];
        default-preference-list = [
          "SHA512"
          "SHA384"
          "SHA256"
          "AES256"
          "AES192"
          "AES"
          "ZLIB"
          "BZIP2"
          "ZIP"
          "Uncompressed"
        ];
        cert-digest-algo = "SHA512";
        s2k-digest-algo = "SHA512";
        s2k-cipher-algo = "AES256";
        charset = "utf-8";
        no-comments = true;
        no-emit-version = true;
        no-greeting = true;
        keyid-format = "0xlong";
        list-options = [ "show-uid-validity" ];
        verify-options = [ "show-uid-validity" ];
        with-fingerprint = true;
        require-cross-certification = true;
        require-secmem = true;
        no-symkey-cache = true;
        armor = true;
      };
    };

  };
}
