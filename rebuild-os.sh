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

export NH_FLAKE="$(git rev-parse --show-toplevel)"

print_usage() {
    echo 'Usage: ./rebuild-os <action> <host> [OPTIONS...]' >&2
    exit 2
}

darkman_() {
    if command -v darkman &>/dev/null; then
        darkman "$@"
    else
        nix run nixpkgs#darkman -- "$@"
    fi
}

nh_() {
    if command -v nh &>/dev/null; then
        nh "$@"
    else
        nix run nixpkgs#nh -- "$@"
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

nh_ os "$rebuild_command" -H "$nix_host" "$@"

if [ "$rebuild_command" != "switch" ] && [ "$rebuild_command" != "test" ]; then
  # Return early if not switching nor testing
  exit 0
fi

if [ "$(darkman_ get)" = "light" ]; then
    exec hm-light-activate
else
    exec hm-dark-activate
fi

systemctl --user restart nm-applet
