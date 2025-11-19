# Kubernetes Volume Snapshot Controller
# Required for CSI snapshot functionality
# https://github.com/kubernetes-csi/external-snapshotter

# Snapshot Controller via Helm (includes CRDs)
resource "helm_release" "snapshot_controller" {
  name       = "snapshot-controller"
  repository = "https://piraeus.io/helm-charts/"
  chart      = "snapshot-controller"
  version    = "3.0.5"
  namespace  = "kube-system"

  # Enable validation webhook
  set {
    name  = "webhook.enabled"
    value = "true"
  }

  depends_on = [
    helm_release.cilium
  ]
}
