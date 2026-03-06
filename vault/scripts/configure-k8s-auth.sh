#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="${NAMESPACE:-vault}"
VAULT_ADDR="${VAULT_ADDR:-http://vault.vault.svc:8200}"
ROOT_TOKEN=$(cat /tmp/root_token.txt)

export VAULT_ADDR
export VAULT_TOKEN="$ROOT_TOKEN"

vault auth enable kubernetes || true

TOKEN_REVIEWER_JWT=$(
  kubectl get secret \
    $(kubectl get serviceaccount vault-token-reviewer -n "$NAMESPACE" -o jsonpath='{.secrets[0].name}') \
    -n "$NAMESPACE" \
    -o jsonpath='{.data.token}' | base64 --decode
)

KUBE_CA_CERT=$(
  kubectl config view --raw --minify --flatten \
    -o jsonpath='{.clusters[0].cluster.certificate-authority-data}' | base64 --decode
)

vault write auth/kubernetes/config \
  token_reviewer_jwt="$TOKEN_REVIEWER_JWT" \
  kubernetes_host="https://kubernetes.default.svc:443" \
  kubernetes_ca_cert="$KUBE_CA_CERT"

vault policy write kv-read /vault-config/policies/kv-read-policy.hcl
vault policy write db-dynamic /vault-config/policies/db-dynamic-policy.hcl

vault write auth/kubernetes/role/app-kv-reader \
  bound_service_account_names="app-kv-reader-sa" \
  bound_service_account_namespaces="default" \
  policies="kv-read" \
  ttl="1h"

vault write auth/kubernetes/role/app-db-user \
  bound_service_account_names="app-db-user-sa" \
  bound_service_account_namespaces="default" \
  policies="db-dynamic" \
  ttl="1h"
