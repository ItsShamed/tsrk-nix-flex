#!/bin/sh

if [ $# -ne 2 ]; then
    echo "Usage: ./get_option.sh <host> <attrPath>" 1>&2
    exit 1
fi

CONFIG_PREFIX="let flake = import $(nix flake metadata --json | jq .path -r); in flake.nixosConfigurations.$1"

nix run nixpkgs#nixos-option -- --config_expr "${CONFIG_PREFIX}.config" --options_expr "${CONFIG_PREFIX}.options" "$2"
