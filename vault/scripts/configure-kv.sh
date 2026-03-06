#!/usr/bin/env bash
set -euo pipefail

export VAULT_TOKEN=$(cat /tmp/root_token.txt)

vault secrets enable -path=secret -version=2 kv || true

vault kv put secret/app/config \
  api_key="demo-api-key" \
  value="demo-config-value"

vault kv get secret/app/config >/dev/null
echo "KV v2 configured with sample secret."
