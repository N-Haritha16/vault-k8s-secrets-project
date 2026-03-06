#!/usr/bin/env bash
set -euo pipefail

echo "[test-ha-cluster] Checking Vault HA status..."

POD=$(kubectl -n vault get pod -l app.kubernetes.io/name=vault -o jsonpath='{.items[0].metadata.name}')
STATUS=$(kubectl -n vault exec "$POD" -- vault status -format=json)

echo "$STATUS" | jq '.ha_enabled, .initialized' | grep true >/dev/null
echo "[test-ha-cluster] OK"
