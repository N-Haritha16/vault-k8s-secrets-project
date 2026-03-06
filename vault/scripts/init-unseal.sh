#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="${NAMESPACE:-vault}"

POD0=$(kubectl -n "$NAMESPACE" get pod -l app.kubernetes.io/name=vault -o jsonpath='{.items[0].metadata.name}')

kubectl -n "$NAMESPACE" exec "$POD0" -- \
  vault operator init -key-shares=3 -key-threshold=2 -format=json > /tmp/keys.json

jq -r ".unseal_keys_b64[]" /tmp/keys.json > /tmp/unseal_keys.txt
jq -r ".root_token" /tmp/keys.json > /tmp/root_token.txt

i=0
for pod in $(kubectl -n "$NAMESPACE" get pod -l app.kubernetes.io/name=vault -o jsonpath='{.items[*].metadata.name}'); do
  for key in $(head -n 2 /tmp/unseal_keys.txt); do
    kubectl -n "$NAMESPACE" exec "$pod" -- vault operator unseal "$key"
  done
  i=$((i+1))
done

echo "Vault initialized and unsealed. Root token stored in /tmp/root_token.txt"
