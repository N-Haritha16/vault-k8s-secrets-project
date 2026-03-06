#!/usr/bin/env bash
set -euo pipefail

echo "[test-db-engine] Verifying dynamic DB credentials..."

CREDS_JSON=$(vault read -format=json database/creds/app-role)
USERNAME=$(echo "$CREDS_JSON" | jq -r .data.username)
PASSWORD=$(echo "$CREDS_JSON" | jq -r .data.password)

test -n "$USERNAME"
test -n "$PASSWORD"

echo "[test-db-engine] Got dynamic username=$USERNAME"
echo "[test-db-engine] OK (connection test can be added with psql)"
