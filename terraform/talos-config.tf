# Control Plane Machine Configuration
data "talos_machine_configuration" "controlplane" {
  cluster_name       = var.cluster_name
  cluster_endpoint   = "https://${var.controlplane_host}:6443"
  machine_type       = "controlplane"
  machine_secrets    = talos_machine_secrets.this.machine_secrets
  talos_version      = var.talos_version
  kubernetes_version = var.kubernetes_version

  docs     = false
  examples = false

  config_patches = [
    yamlencode({
      machine = {
        network = {
          hostname = "zimaboard-cp"
        }
        install = {
          disk = "/dev/mmcblk0" # ZimaBoard eMMC
          # Use custom installer with Tailscale extension
          image = var.talos_schematic_id != "" ? "factory.talos.dev/installer/${var.talos_schematic_id}:${var.talos_version}" : "ghcr.io/siderolabs/installer:${var.talos_version}"
        }
        features = {
          kubePrism = {
            enabled = true
            port    = 7445
          }
        }
      }
      cluster = {
        network = {
          cni = {
            name = "none" # Install Cilium separately
          }
        }
        proxy = {
          disabled = true # Using Cilium kube-proxy replacement
        }
      }
    }),
    # Tailscale Extension Configuration
    var.tailscale_authkey != "" ? yamlencode({
      apiVersion = "v1alpha1"
      kind       = "ExtensionServiceConfig"
      name       = "tailscale"
      environment = [
        "TS_AUTHKEY=${var.tailscale_authkey}"
      ]
    }) : ""
  ]
}

# Worker Machine Configuration
data "talos_machine_configuration" "worker" {
  cluster_name       = var.cluster_name
  cluster_endpoint   = "https://${var.controlplane_host}:6443"
  machine_type       = "worker"
  machine_secrets    = talos_machine_secrets.this.machine_secrets
  talos_version      = var.talos_version
  kubernetes_version = var.kubernetes_version

  docs     = false
  examples = false

  config_patches = [
    yamlencode({
      machine = {
        network = {
          hostname = "minix-worker"
        }
        install = {
          disk = "/dev/sda" # MINIX main disk
          # Use custom installer with Tailscale extension
          image = var.talos_schematic_id != "" ? "factory.talos.dev/installer/${var.talos_schematic_id}:${var.talos_version}" : "ghcr.io/siderolabs/installer:${var.talos_version}"
        }
        kubelet = {
          extraArgs = {
            "max-pods" = "150"
          }
        }
      }
    }),
    # Tailscale Extension Configuration
    var.tailscale_authkey != "" ? yamlencode({
      apiVersion = "v1alpha1"
      kind       = "ExtensionServiceConfig"
      name       = "tailscale"
      environment = [
        "TS_AUTHKEY=${var.tailscale_authkey}"
      ]
    }) : ""
  ]
}
