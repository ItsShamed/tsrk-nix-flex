#!/bin/sh

# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

# This script runs nix garbage collection commands and store optimisation 

set -euo pipefail

sudo_() {
    if [ "$(id -u)" = 0 ]; then
        "$@"
    elif command -v sudo >/dev/null; then
        sudo "$@"
    elif command -v doas >/dev/null; then
        doas "$@"
    else
        echo "wtf are u" >&2
        exit 1
    fi
}

echo "==> Running NH clean"

nh clean all -K 5d --optimise --no-gcroots

echo "==> Cleaning up boot entries"

sudo_ true
sudo_ /run/current-system/bin/switch-to-configuration boot
