# Network Configuration
variable "tailscale_network" {
  description = "Tailscale network CIDR"
  type        = string
  default     = "100.64.0.0/10"
}

# Control Plane Configuration
variable "controlplane_host" {
  description = "ZimaBoard Control Plane IP address (will be set after Talos installation)"
  type        = string
  default     = ""  # Will be filled after initial boot
}

# Worker Configuration
variable "worker_host" {
  description = "MINIX Worker Node IP address (will be set after Talos installation)"
  type        = string
  default     = ""  # Will be filled after initial boot
}

# Cluster Configuration
variable "cluster_name" {
  description = "Kubernetes cluster name"
  type        = string
  default     = "homelab"
}

# Talos Configuration
variable "talos_version" {
  description = "Talos Linux version"
  type        = string
  default     = "v1.9.0"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.31.1"
}

# Storage Configuration
variable "synology_iscsi_target" {
  description = "Synology iSCSI target IQN"
  type        = string
  default     = "iqn.2025-09.homelab.local:k8s-storage"
}

variable "synology_iscsi_portal" {
  description = "Synology iSCSI portal address (Tailscale IP)"
  type        = string
  default     = "100.98.178.58:3260"
}

# Tailscale Configuration
variable "tailscale_authkey" {
  description = "Tailscale authentication key for node registration"
  type        = string
  sensitive   = true
  default     = ""
}

variable "talos_schematic_id" {
  description = "Talos Factory schematic ID (includes Tailscale extension)"
  type        = string
  default     = "" # Will be generated from factory.talos.dev
}

# Secrets (will be injected via GitHub Actions from Bitwarden)
variable "iscsi_chap_username" {
  description = "iSCSI CHAP username"
  type        = string
  sensitive   = true
  default     = ""
}

variable "iscsi_chap_password" {
  description = "iSCSI CHAP password"
  type        = string
  sensitive   = true
  default     = ""
}

# Synology CSI Driver Configuration
variable "synology_host" {
  description = "Synology NAS IP address (Tailscale)"
  type        = string
  default     = "100.98.178.58"
}

variable "synology_dsm_port" {
  description = "Synology DSM port (5000 for HTTP, 5001 for HTTPS)"
  type        = number
  default     = 5001
}

variable "synology_dsm_https" {
  description = "Use HTTPS for DSM connection"
  type        = bool
  default     = true
}

variable "synology_dsm_username" {
  description = "Synology DSM admin username for CSI driver"
  type        = string
  sensitive   = true
  default     = ""
}

variable "synology_dsm_password" {
  description = "Synology DSM admin password for CSI driver"
  type        = string
  sensitive   = true
  default     = ""
}
