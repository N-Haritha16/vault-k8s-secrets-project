#!/usr/bin/env bash
set -euo pipefail

echo "[test-k8s-auth] Verifying Kubernetes auth method..."

vault auth list -format=json | jq '."kubernetes/".type' | grep kubernetes >/dev/null
echo "[test-k8s-auth] OK"
