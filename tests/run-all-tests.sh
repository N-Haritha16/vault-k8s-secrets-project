#!/usr/bin/env bash
set -euo pipefail

./test-ha-cluster.sh
./test-k8s-auth.sh
./test-kv-engine.sh
./test-db-engine.sh
./test-transit-engine.sh
./test-agent-injector.sh

echo "All tests passed."
