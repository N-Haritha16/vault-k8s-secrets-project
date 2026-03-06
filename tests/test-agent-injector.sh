#!/usr/bin/env bash
set -euo pipefail

echo "[test-agent-injector] Checking injected secrets in app pod..."

POD=$(kubectl get pod -n default -l app=sample-app -o jsonpath='{.items[0].metadata.name}')

kubectl -n default exec "$POD" -- test -f /vault/secrets/db-creds.txt
kubectl -n default exec "$POD" -- test -f /vault/secrets/kv-config.txt

echo "[test-agent-injector] OK"
