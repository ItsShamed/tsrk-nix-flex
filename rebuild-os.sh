#!/bin/sh

# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.
#
# SPDX-License-Identifier: MIT

# This script is a wrapper around `nixos-rebuild` and `nom` (nix-output-monitor)
# to make rebuilding a nixos system in this flake more informative while having
# less boilerplate arguments to write manually

set -euo pipefail

print_usage() {
    echo 'Usage: ./rebuild-os <action> <host> [OPTIONS...]' >&2
    exit 2
}

sudo_() {
    if [ "$UID" -eq 0 ]; then
        "$@"
    else
        sudo --preserve-env=NIX_SSHOPTS "$@"
    fi
}

darkman_() {
    if command -v darkman &>/dev/null; then
        darkman "$@"
    else
        nix run nixpkgs#darkman -- "$@"
    fi
}

nom_() {
    if command -v nom &>/dev/null; then
        nom "$@"
    else
        nix run nixpkgs#nix-output-monitor -- "$@"
    fi
}

if [ "$#" -lt 2 ]; then
    print_usage
fi

rebuild_command="$1"
shift 1

nix_host="$1"
shift 1

NIX_SSHOPTS="-i $HOME/.ssh/id_ed25519"
export NIX_SSHOPTS

# Ensure user is logged in as root as sudo prompt will not be available
# afterwards, because we are also piping stderr to nom
sudo_ true

(sudo_ nixos-rebuild $rebuild_command --fast -L -v --log-format internal-json \
    --flake .#"$nix_host" "$@") |& nom_ --json

if [ "$(darkman_ get)" = "light" ]; then
    exec hm-light-activate
else
    exec hm-dark-activate
fi

systemctl --user restart nm-applet
