# Kubernetes Provider Configuration
# Uses kubeconfig from talos_cluster_kubeconfig resource
provider "kubernetes" {
  host                   = var.controlplane_host != "" ? "https://${var.controlplane_host}:6443" : null
  cluster_ca_certificate = var.controlplane_host != "" ? base64decode(talos_cluster_kubeconfig.this[0].kubernetes_client_configuration.ca_certificate) : null
  client_certificate     = var.controlplane_host != "" ? base64decode(talos_cluster_kubeconfig.this[0].kubernetes_client_configuration.client_certificate) : null
  client_key             = var.controlplane_host != "" ? base64decode(talos_cluster_kubeconfig.this[0].kubernetes_client_configuration.client_key) : null
}

# Helm Provider Configuration
provider "helm" {
  kubernetes {
    host                   = var.controlplane_host != "" ? "https://${var.controlplane_host}:6443" : null
    cluster_ca_certificate = var.controlplane_host != "" ? base64decode(talos_cluster_kubeconfig.this[0].kubernetes_client_configuration.ca_certificate) : null
    client_certificate     = var.controlplane_host != "" ? base64decode(talos_cluster_kubeconfig.this[0].kubernetes_client_configuration.client_certificate) : null
    client_key             = var.controlplane_host != "" ? base64decode(talos_cluster_kubeconfig.this[0].kubernetes_client_configuration.client_key) : null
  }
}
