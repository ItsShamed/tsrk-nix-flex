# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, inputs, ... }:

{ pkgs, ... }:

let RPackages = with pkgs.rPackages; [ FactoMineR corrplot ];
in {
  key = ./.;

  imports = with self.homeManagerModules; [
    profile-x11
    inputs.spotify-notifyx.homeManagerModules.default
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  tsrk = {
    premid.enable = true;
    packages.dev.enable = true;
    packages.compat.enable = true;
    packages.ops.enable = true;
  };

  services.flatpak = {
    enable = true;
    packages = [ "com.fightcade.Fightcade" ];
    update = {
      onActivation = true;
      auto = {
        enable = true;
        onCalendar = "weekly";
      };
    };
  };

  accounts.email.accounts = {
    tsrk = rec {
      address = "tsrk@tsrk.me";
      userName = address;
      realName = "tsrk.";
      imap = {
        host = "zimbra002.pulseheberg.com";
        port = 993;
      };
      smtp = {
        host = "zimbra002.pulseheberg.com";
        port = 587;
        tls = {
          enable = true;
          useStartTls = true;
        };
      };
      signature = {
        showSignature = "append";
        text = ''
          tsrk.
          https://tsrk.me
        '';
      };
      primary = true;
      thunderbird.enable = true;
    };
  };

  programs.git = {
    userName = "tsrk.";
    signing = {
      signByDefault = true;
      key = "D1C2AD054267D54D248A4F43EBD46BB3049B56D6";
    };
    userEmail = "tsrk@tsrk.me";
  };

  home.packages = with pkgs; [
    deadnix
    teams-for-linux
    (rWrapper.override { packages = RPackages; })
    (rstudioWrapper.override { packages = RPackages; })
    ventoy-full
  ];

  home.sessionPath = [ "$HOME/.cargo/bin" "$GOPATH/bin" "$HOME/go/bin" ];
}
