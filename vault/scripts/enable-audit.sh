#!/usr/bin/env bash
set -euo pipefail

export VAULT_TOKEN=$(cat /tmp/root_token.txt)

vault audit enable file file_path=/vault/logs/audit.log || true

echo "Audit logging enabled at /vault/logs/audit.log"
