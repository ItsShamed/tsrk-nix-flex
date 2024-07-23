#!/bin/sh

set -euo pipefail

kp_path="profiles/system/agenix/bootstrap-keys"
pub_key_path="$kp_path/ssh_host_ed25519_key.pub"
old_pub_key=$(cat "$pub_key_path")

echo "Removing existing bootstrap keys"
rm -fv "$kp_path"/*

echo "Generating new bootstrap keys"
ssh-keygen -N "" -C "tsrk-bootstrap" -t ed25519 -f "$kp_path/ssh_host_ed25519_key"

echo "Replacing old public key with generated one"
new_pub_key=$(cat "$pub_key_path")

sed -i "s;$old_pub_key;$new_pub_key;" secrets.nix

echo "Rekeying secrets"
agenix -r
