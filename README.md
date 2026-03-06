# vault-k8s-secrets-project

Demo project for managing Kubernetes application secrets with HashiCorp Vault and a local k3s cluster via Docker Compose.

## Prerequisites

- Docker / Docker Desktop
- docker compose (v2+)
- kubectl
- Helm
- Node.js (optional, only if you want to run the app outside Docker)

## Quick start

1. Clone the repo:

   ```bash
   git clone https://github.com/N-Haritha16/vault-k8s-secrets-project.git
   cd vault-k8s-secrets-project

2. Copy the example env file if needed:

bash
cp .env.example .env

3. Start the local cluster and app:

bash
docker compose up -d --build

- This will start:

a. k3s – local Kubernetes(k8s) cluster.

b. app – sample Node.js app on port 3000.

c. tests – container that runs basic checks and then exits.

4. Verify services:

bash
docker compose ps

You should see k3s and app as healthy containers.

5. Point kubectl at the local k3s cluster:

bash
export KUBECONFIG=$(pwd)/kubeconfig/kubeconfig
kubectl get nodes

## Deploying Vault

1. Create the vault namespace:

bash
kubectl create namespace vault

2. Install Vault with Helm using the provided values:

bash
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update
helm upgrade --install vault hashicorp/vault \
  --namespace vault \
  -f values.yaml

3. Wait for Vault pods to be ready, then initialize and unseal according to the steps in docs/ (and capture root_token.txt / unseal_keys.txt locally but never commit them).

## Deploying the demo application

1. Apply the Kubernetes manifests from k8s/:

bash
kubectl apply -f k8s/

2. Confirm the app pod is running:

bash
kubectl get pods -n default

3. Port-forward or use the Docker published port to hit the health endpoint:

bash
curl http://localhost:3000/health

## Project structure

- app/ – Node.js sample application.

- docker-compose.yml – local k3s + app + tests orchestration.

- helm/ – Vault Helm-related files.

- k8s/ – Kubernetes manifests for the demo app and supporting resources.

- vault/ – Vault configuration snippets and scripts.

- docs/ – screenshots and additional documentation.

- values.yaml – Helm values for the Vault release.

## Security notes

1. Do not commit root_token.txt, unseal_keys.txt, keys.json, or any real credentials.

2. .gitignore is configured to keep sensitive files and generated artefacts out of version control.

3. This is a local, educational setup and is not a production-ready Vault deployment.