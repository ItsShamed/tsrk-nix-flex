# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ self, inputs, ... }:

{ pkgs, lib, ... }:

{
  key = ./.;

  imports = with self.homeManagerModules; [
    fcitx5
    profile-x11
    inputs.spotify-notifyx.homeManagerModules.default
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  tsrk = {
    premid.enable = true;
    fcitx5 = {
      enable = true;
      groups = {
        "FR-dev/JP" = {
          defaultLayout = "us_qwerty-fr";
          defaultInputMethod = "mozc";
          items = {
            keyboard-us_qwerty-fr = "";
            mozc = "";
          };
        };
      };
    };
    packages.dev.enable = true;
    packages.compat.enable = true;
    packages.ops.enable = true;
    packages.music-production.enable = true;

    shell.kubeswitch.enable = true;
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
      key = "72F6EF68BE1CF6A6";
    };
    userEmail = "tsrk@tsrk.me";
  };

  programs.ssh.matchBlocks = let
    forgeHost = extraConfig:
      {
        user = "root";
        identityFile = "~/.ssh/id_ed25519_forge";
      } // extraConfig;
    forgeBastion = hostname: extraConfig:
      forgeHost ({ inherit hostname; } // extraConfig);
    proxiedForgeHost = proxyJump: extraConfig:
      lib.hm.dag.entryAfter [ proxyJump ]
      (forgeHost ({ inherit proxyJump; } // extraConfig));
  in {
    # Forge Config
    ## Bastions and firewalls
    "3ie-bastion" = forgeBastion "bastion.iaas.3ie.epita.fr" { };
    "fw-cri" = forgeBastion "91.243.117.1" { };
    "lre-bastion" = forgeBastion "admin-svc.lre.iaas.epita.fr" { };
    "os-bastion" = forgeBastion "bastion.iaas.cri.epita.fr" { port = 2222; };
    "play-bastion" = forgeBastion "bastion.cri-playground.iaas.epita.fr" { };

    ## Specifc host configuration
    "gitlab.cri.epita.fr" = lib.hm.dag.entryBefore [ "*.cri.epita.fr" ] {
      proxyJump = "none";
      extraOptions.GSSAPIAuthentication = "yes";
    };
    "ssh.cri.epita.fr" = lib.hm.dag.entryBefore [ "*.cri.epita.fr" ] {
      proxyJump = "none";
      extraOptions = {
        GSSAPIAuthentication = "yes";
        GSSAPIDelegateCredentials = "yes";
      };
    };
    "git.forge.epita.fr" = lib.hm.dag.entryBefore [ "*.forge.epita.fr" ] {
      proxyJump = "none";
      extraOptions.GSSAPIAuthentication = "yes";
    };

    ## Proxied hosts
    "*.3ie.fr" = proxiedForgeHost "fw-cri" { };
    "*.3ie.openstack.epita.fr" = proxiedForgeHost "3ie-bastion" { };
    "*.cri.epita.fr" = proxiedForgeHost "fw-cri" { };
    "*.forge.epita.fr" = proxiedForgeHost "fw-cri" { };
    "*.cri.openstack.epita.fr" = proxiedForgeHost "os-bastion" { };
    "*.cri_playground.openstack.epita.fr" = proxiedForgeHost "play-bastion" { };
    "*.lre.openstack.epita.fr" = proxiedForgeHost "lre-bastion" { };
  };

  home.packages = with pkgs; [
    deadnix
    teams-for-linux
    magic-wormhole

    # TODO: Bring back when they finish being silly
    # https://github.com/ventoy/Ventoy/issues/3224
    # https://github.com/NixOS/nixpkgs/issues/404663
    # ventoy-full
    tor
    tor-browser
  ];

  programs.cava = {
    enable = lib.mkDefault true;
    settings = {
      general = {
        framerate = 60;
        autosens = 1;
        sensitivity = 11;
        bars = 18;
      };
      input.method = "pipewire";
      output = {
        channels = "mono";
        mono_option = "average";
      };
      smoothing.noise_reduction = 65;
    };
  };

  home.sessionPath = [ "$HOME/.cargo/bin" "$GOPATH/bin" "$HOME/go/bin" ];
}
