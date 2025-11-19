# Cilium CNI Installation via Helm
# https://docs.cilium.io/en/stable/installation/k8s-install-helm/

resource "helm_release" "cilium" {
  name       = "cilium"
  repository = "https://helm.cilium.io/"
  chart      = "cilium"
  version    = "1.16.5"
  namespace  = "kube-system"

  # Talos Linux specific settings
  set {
    name  = "securityContext.privileged"
    value = "true"
  }

  set {
    name  = "cgroup.autoMount.enabled"
    value = "false"
  }

  set {
    name  = "cgroup.hostRoot"
    value = "/sys/fs/cgroup"
  }

  # Kubernetes API Server endpoint
  set {
    name  = "k8sServiceHost"
    value = var.controlplane_host
  }

  set {
    name  = "k8sServicePort"
    value = "6443"
  }

  # kube-proxy replacement (recommended)
  set {
    name  = "kubeProxyReplacement"
    value = "true"
  }

  # Direct routing device (required for Talos)
  set {
    name  = "devices"
    value = "enp2s0"
  }

  set {
    name  = "ipv4NativeRoutingCIDR"
    value = "10.0.0.0/8"
  }

  # Enable Hubble for network observability (optional)
  set {
    name  = "hubble.enabled"
    value = "true"
  }

  set {
    name  = "hubble.relay.enabled"
    value = "true"
  }

  set {
    name  = "hubble.ui.enabled"
    value = "true"
  }

  # Wait for Cilium to be ready before considering this complete
  wait          = true
  wait_for_jobs = true
  timeout       = 600

  depends_on = [
    talos_machine_bootstrap.this
  ]
}
