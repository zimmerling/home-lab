# Synology CSI Driver Installation via Helm
# https://github.com/SynologyOpenSource/synology-csi
# Helm chart: https://christian-schlichtherle.github.io/synology-csi-chart

# Namespace for CSI driver with privileged pod security
resource "kubernetes_namespace" "synology_csi" {
  metadata {
    name = "synology-csi"

    # CSI drivers require privileged access to the host system
    # Allow privileged pods in this namespace
    labels = {
      "pod-security.kubernetes.io/enforce" = "privileged"
      "pod-security.kubernetes.io/audit"   = "privileged"
      "pod-security.kubernetes.io/warn"    = "privileged"
    }
  }

  depends_on = [
    helm_release.cilium
  ]
}

# Secret for Synology NAS credentials
resource "kubernetes_secret" "synology_csi_credentials" {
  metadata {
    name      = "synology-csi-credentials"
    namespace = kubernetes_namespace.synology_csi.metadata[0].name
  }

  data = {
    "client-info.yml" = <<-EOT
      clients:
      - host: ${var.synology_host}
        port: ${var.synology_dsm_port}
        https: ${var.synology_dsm_https}
        username: ${var.synology_dsm_username}
        password: ${var.synology_dsm_password}
    EOT
  }

  type = "Opaque"
}

# Synology CSI Driver Helm Release (Talos-compatible fork by zebernst)
# https://github.com/zebernst/synology-csi-talos
# Using v0.9.4 - latest stable release with Helm chart
resource "helm_release" "synology_csi" {
  name      = "synology-csi"
  chart     = "https://github.com/zebernst/synology-csi-talos/releases/download/synology-csi-0.9.4/synology-csi-0.9.4.tgz"
  namespace = kubernetes_namespace.synology_csi.metadata[0].name

  # Use existing secret for credentials
  set {
    name  = "clientInfoSecret.create"
    value = "false"
  }

  set {
    name  = "clientInfoSecret.name"
    value = kubernetes_secret.synology_csi_credentials.metadata[0].name
  }

  # Storage classes configuration
  set {
    name  = "storageClasses.iscsi-retain.name"
    value = "synology-iscsi-retain"
  }

  set {
    name  = "storageClasses.iscsi-retain.reclaimPolicy"
    value = "Retain"
  }

  set {
    name  = "storageClasses.iscsi-retain.parameters.protocol"
    value = "iscsi"
  }

  set {
    name  = "storageClasses.iscsi-retain.parameters.fsType"
    value = "ext4"
  }

  set {
    name  = "storageClasses.iscsi-delete.name"
    value = "synology-iscsi-delete"
  }

  set {
    name  = "storageClasses.iscsi-delete.reclaimPolicy"
    value = "Delete"
  }

  set {
    name  = "storageClasses.iscsi-delete.parameters.protocol"
    value = "iscsi"
  }

  set {
    name  = "storageClasses.iscsi-delete.parameters.fsType"
    value = "ext4"
  }

  # Volume snapshot support (disabled for now)
  set {
    name  = "volumeSnapshotClasses.iscsi-delete.disabled"
    value = "true"
  }

  set {
    name  = "volumeSnapshotClasses.iscsi-retain.disabled"
    value = "true"
  }

  # Node selector for worker nodes with iSCSI support
  # Talos includes iSCSI initiator by default
  set {
    name  = "node.enableAffinityForCSINode"
    value = "false"
  }

  # Wait for deployment to be ready
  wait          = true
  wait_for_jobs = true
  timeout       = 600

  depends_on = [
    kubernetes_secret.synology_csi_credentials,
    helm_release.cilium
  ]
}
