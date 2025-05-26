#!/bin/sh

# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.
#
# SPDX-License-Identifier: MIT

# This script retrieves a single nixos-option from an host

# TODO: Make this script gather options from lsp-hints.nix

set -euo pipefail

if [ $# -lt 2 ]; then
    echo "Usage: ./get_option.sh <host> <attrPath>" 1>&2
    exit 1
fi

host=$1
shift
attrPath=$1
shift

CONFIG_PREFIX="let flake = import $(nix flake metadata --json | jq .path -r); in flake.nixosConfigurations.$host"

command=

if command -v nixos-option &>/dev/null; then
    command=nixos-option
else
    command=nix run nixpkgs#nixos-option --
fi

$command --flake ".#$host" "$attrPath" $@
