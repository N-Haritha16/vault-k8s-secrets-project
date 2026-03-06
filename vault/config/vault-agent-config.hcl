pid_file = "/tmp/vault-agent.pid"

auto_auth {
  method "kubernetes" {
    mount_path = "auth/kubernetes"
    config = {
      role = "app-db-user"
    }
  }

  sink "file" {
    config = {
      path = "/vault/.token"
    }
  }
}
