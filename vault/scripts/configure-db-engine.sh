#!/usr/bin/env bash
set -euo pipefail

export VAULT_TOKEN=$(cat /tmp/root_token.txt)

vault secrets enable database || true

vault write database/config/postgresql \
  plugin_name="postgresql-database-plugin" \
  connection_url="postgresql://vaultadmin:vaultadminpass@postgres:5432/appdb?sslmode=disable" \
  allowed_roles="app-role"

vault write database/roles/app-role \
  db_name="postgresql" \
  creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT CONNECT ON DATABASE appdb TO \"{{name}}\";" \
  default_ttl="1m" \
  max_ttl="5m"

vault read database/creds/app-role >/dev/null
echo "Database secrets engine configured."
