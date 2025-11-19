# Talos Configuration Outputs
output "talosconfig" {
  description = "Talos client configuration for talosctl"
  value       = data.talos_client_configuration.this.talos_config
  sensitive   = true
}

# Kubeconfig Output
output "kubeconfig" {
  description = "Kubernetes configuration for kubectl"
  value       = var.controlplane_host != "" ? talos_cluster_kubeconfig.this[0].kubeconfig_raw : "Cluster not yet configured"
  sensitive   = true
}

# Cluster Information
output "cluster_endpoint" {
  description = "Kubernetes API endpoint"
  value       = var.controlplane_host != "" ? "https://${var.controlplane_host}:6443" : "Not configured yet"
}

output "cluster_name" {
  description = "Kubernetes cluster name"
  value       = var.cluster_name
}

# Node Information
output "controlplane_node" {
  description = "Control plane node address"
  value       = var.controlplane_host != "" ? var.controlplane_host : "Not configured yet"
}

output "worker_node" {
  description = "Worker node address"
  value       = var.worker_host != "" ? var.worker_host : "Not configured yet"
}
