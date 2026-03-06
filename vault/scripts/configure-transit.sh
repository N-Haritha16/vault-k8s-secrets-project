#!/usr/bin/env bash
set -euo pipefail

export VAULT_TOKEN=$(cat /tmp/root_token.txt)

vault secrets enable transit || true

vault write -f transit/keys/app-transit-key

PLAINTEXT=$(printf "sensitive-data" | base64)
CIPHERTEXT=$(vault write -field=ciphertext transit/encrypt/app-transit-key plaintext="$PLAINTEXT")
vault write -field=plaintext transit/decrypt/app-transit-key ciphertext="$CIPHERTEXT" | base64 --decode >/dev/null

echo "Transit engine configured and tested."
