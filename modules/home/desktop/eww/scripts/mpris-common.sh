#!/bin/sh

# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

CACHE_DIR="$HOME/.cache/eww-mpris"
TEMP_DIR="/tmp/eww-mpris"

graceful_exit() {
    echo "Bye!" >&2
    trap - SIGINT SIGTERM
    exit 0
}

get_cached() {

    cover="$1"
    shift

    mkdir -p "$CACHE_DIR"
    mkdir -p "$TEMP_DIR"

    cover_hash=$(echo "$cover" | md5sum | cut -d ' ' -f 1)
    lock_file="$TEMP_DIR/.cover-${cover_hash}.lock"
    target="$CACHE_DIR/cover-$cover_hash.jpg"
    {
        flock -x 200

        if [ -f "$target" ]; then
          echo "$target"
          return 0
        fi

        if ! curl -fsSL "$cover" -o "$target"; then
          echo "Failed to download cover at $cover" >&2
          echo ""
          return 1
        fi

        echo "$target"
        return 0
    } 200>"$lock_file"
}

trap graceful_exit SIGINT SIGTERM
