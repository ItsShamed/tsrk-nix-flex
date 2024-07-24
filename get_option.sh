#!/bin/sh

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

$command --config_expr "${CONFIG_PREFIX}.config" --options_expr "${CONFIG_PREFIX}.options" "$attrPath" $@
