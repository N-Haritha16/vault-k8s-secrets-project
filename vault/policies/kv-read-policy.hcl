# Read-only access to secrets under secret/data/app/*
path "secret/data/app/*" {
  capabilities = ["read", "list"]
}
