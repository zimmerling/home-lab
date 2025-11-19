terraform {
  cloud {
    hostname     = "app.terraform.io"
    organization = "zimmerling-lab"

    workspaces {
      name = "talos-homelab"
    }
  }
}
