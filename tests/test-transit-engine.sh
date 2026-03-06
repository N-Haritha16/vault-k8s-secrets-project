#!/usr/bin/env bash
set -euo pipefail

echo "[test-transit-engine] Verifying Transit engine..."

PLAINTEXT=$(printf "ping" | base64)
CIPHERTEXT=$(vault write -field=ciphertext transit/encrypt/app-transit-key plaintext="$PLAINTEXT")
DECRYPTED=$(vault write -field=plaintext transit/decrypt/app-transit-key ciphertext="$CIPHERTEXT" | base64 --decode)

test "$DECRYPTED" = "ping"
echo "[test-transit-engine] OK"
