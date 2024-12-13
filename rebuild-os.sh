#!/bin/sh

set -euo pipefail

print_usage() {
    echo 'Usage: ./rebuild-os <action> <host> [OPTIONS...]' >&2
    exit 2
}

sudo_() {
    if [ "$UID" -eq 0 ]; then
        "$@"
    else
        sudo "$@"
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
