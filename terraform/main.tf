# Talos Machine Secrets
resource "talos_machine_secrets" "this" {
  talos_version = var.talos_version
}

# Talos Client Configuration
data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  nodes                = var.controlplane_host != "" ? [var.controlplane_host] : []
  endpoints            = var.controlplane_host != "" ? [var.controlplane_host] : []
}

# Control Plane Configuration
resource "talos_machine_configuration_apply" "controlplane" {
  client_configuration        = data.talos_client_configuration.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration
  node                        = var.controlplane_host

  count = var.controlplane_host != "" ? 1 : 0
}

# Worker Configuration
resource "talos_machine_configuration_apply" "worker" {
  client_configuration        = data.talos_client_configuration.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
  node                        = var.worker_host

  count = var.worker_host != "" ? 1 : 0
}

# Bootstrap the cluster
resource "talos_machine_bootstrap" "this" {
  client_configuration = data.talos_client_configuration.this.client_configuration
  endpoint             = var.controlplane_host
  node                 = var.controlplane_host

  depends_on = [
    talos_machine_configuration_apply.controlplane
  ]

  count = var.controlplane_host != "" ? 1 : 0
}

# Generate Kubeconfig
resource "talos_cluster_kubeconfig" "this" {
  client_configuration = data.talos_client_configuration.this.client_configuration
  endpoint             = var.controlplane_host
  node                 = var.controlplane_host

  depends_on = [
    talos_machine_bootstrap.this
  ]

  count = var.controlplane_host != "" ? 1 : 0
}

# Cluster health check - disabled due to internal IP mismatch with Tailscale
# Use kubectl/talosctl for health checks instead
# data "talos_cluster_health" "this" {
#   client_configuration = data.talos_client_configuration.this.client_configuration
#   control_plane_nodes = [
#     var.controlplane_host
#   ]
#   worker_nodes = [
#     var.worker_host
#   ]
#   endpoints = [
#     var.controlplane_host
#   ]
#
#   depends_on = [
#     talos_machine_bootstrap.this
#   ]
#
#   count = var.controlplane_host != "" && var.worker_host != "" ? 1 : 0
# }
