#!/usr/bin/env bash
set -euo pipefail

echo "[test-kv-engine] Verifying KV v2..."

vault kv get secret/app/config >/dev/null
echo "[test-kv-engine] OK"
