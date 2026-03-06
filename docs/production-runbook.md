
***

## production-runbook.md

```markdown
# Production Runbook

This runbook describes how to operate the demo Vault + k3s setup in a production-like way for this exercise.

1. Daily checks

- Confirm Vault pods are running:

  kubectl get pods -n vault

- Check Vault status:

kubectl -n vault exec -it deploy/vault -- vault status

- Verify the application pod and health endpoint:

kubectl get pods -n default
curl http://localhost:3000/health

2. Start-up procedure

- Start the Docker-based environment:

docker compose up -d

- Export kubeconfig:

export KUBECONFIG=$(pwd)/kubeconfig/kubeconfig

- Ensure Vault is initialized and unsealed. If this is a fresh environment:

a. Initialize Vault and capture unseal keys and root token.

b. Unseal Vault using the stored keys.

c. Enable required auth methods and secret engines (Kubernetes auth, KV, etc.).

d. Apply policies and roles for the application.

- Redeploy the application if needed:

kubectl apply -f k8s/

3. Handling common incidents

App cannot read secrets from Vault

- Check app logs:

kubectl logs deploy/app -n default

- Verify Vault token authentication:

a. Ensure the Kubernetes auth method is enabled.

b. Confirm the ServiceAccount and Vault role mapping match.

- Restart the app deployment:

kubectl rollout restart deploy/app -n default
Vault is sealed

- Check status:

kubectl -n vault exec -it deploy/vault -- vault status

- Unseal using the stored unseal keys (from unseal_keys.txt stored securely outside git):

kubectl -n vault exec -it deploy/vault -- vault operator unseal
Repeat until Vault reports sealed: false.

4. Backup and recovery (demo scope)

- Backup:

a. Export Vault configuration and policies as code where possible.

b. Keep a secure offline copy of unseal keys and initial root token.

- Recovery steps:

a. Recreate the k3s environment with docker compose up -d.

b. Reinstall Vault via Helm with the same values.yaml.

c. Restore Raft storage or reconfigure secrets and policies manually for the demo.

d. Redeploy the application and verify it can read secrets.

5. Shutdown procedure

Optionally scale app and Vault deployments down for a clean stop.

## Stop Docker services:

docker compose down
Ensure any sensitive tokens/keys remain stored only in your secure local location, not in the repository.