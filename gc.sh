#!/bin/sh

# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

# This script runs nix garbage collection commands and store optimisation 

set -euo pipefail

sudo_() {
    if [ "$UID" -eq 0 ]; then
        "$@"
    else
        sudo "$@"
    fi
}

echo "==> Running GC on 'user' store paths"

nix-collect-garbage -d --delete-older-than 5d -vv

echo "==> Running GC on 'root' store paths"

sudo_ true
sudo_ nix-collect-garbage -d -vv

echo "==> Cleaning up boot entries"

sudo_ true
sudo_ /run/current-system/bin/switch-to-configuration boot

echo "==> Running Nix store optimisation with hard-links"

nix store optimise -vv -L
