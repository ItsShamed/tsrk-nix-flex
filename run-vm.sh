#!/bin/sh

# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.
#
# SPDX-License-Identifier: MIT

# This script is a wrapper around `nixos-rebuild` and `nom` (nix-output-monitor)
# to make running a nixos VM in this flake more informative while having
# less boilerplate arguments to write manually

set -euo pipefail

export NH_FLAKE="$(git rev-parse --show-toplevel)"

print_usage() {
    echo 'Usage: ./run-vm <host> [OPTIONS...]' >&2
    exit 2
}

if [ "$#" -lt 1 ]; then
    print_usage
fi

nix_host="$1"
shift 1

NIX_SSHOPTS="-i $HOME/.ssh/id_ed25519"
export NIX_SSHOPTS

nh os build-vm -H "$nix_host" .

"./result/bin/run-$nix_host-vm" -smp 4 -m 8192 -vga qxl
