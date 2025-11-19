# Talos Kubernetes Cluster - OpenTofu Configuration

OpenTofu (Terraform) configuration for deploying a Talos Linux Kubernetes cluster.

## Architecture

- **Control Plane**: ZimaBoard (4GB RAM, 16GB eMMC)
- **Worker**: MINIX B4 Plus (16GB RAM, 512GB storage)
- **Storage**: Synology NAS via iSCSI (over Tailscale)
- **State Backend**: Terraform Cloud
- **Secrets**: Bitwarden (via GitHub Actions)

## Prerequisites

1. **OpenTofu installed** (>= 1.6.0)
2. **Terraform Cloud** account and workspace created
3. **Terraform Cloud token** configured via environment variable:
   ```bash
   # Get token from Bitwarden
   export TF_TOKEN_app_terraform_io="YOUR_TOKEN"

   # Or set it permanently in your shell config (~/.bashrc, ~/.zshrc):
   echo 'export TF_TOKEN_app_terraform_io="YOUR_TOKEN"' >> ~/.bashrc
   ```

   Note: OpenTofu/Terraform automatically reads `TF_TOKEN_app_terraform_io` for authentication.

## Quick Start

### 1. Configure Backend

Edit `backend.tf` and replace `<YOUR_ORG>`:
```hcl
organization = "your-org-name"
```

### 2. Set Variables

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your node IPs (after Talos installation).

### 3. Initialize and Apply

```bash
tofu init
tofu plan
tofu apply
```

### 4. Get Credentials

```bash
# Get talosconfig
tofu output -raw talosconfig > ~/.talos/config

# Get kubeconfig
tofu output -raw kubeconfig > ~/.kube/config

# Test
kubectl get nodes
```

## File Structure

```
terraform/
├── backend.tf              # Terraform Cloud backend
├── versions.tf             # Provider versions
├── variables.tf            # Input variables
├── terraform.tfvars        # Your values (gitignored!)
├── terraform.tfvars.example
├── main.tf                 # Main resources
├── talos-config.tf         # Talos configurations
├── outputs.tf              # Outputs
└── README.md
```

## Commands

All commands use `tofu` (OpenTofu CLI):

```bash
tofu init      # Initialize
tofu plan      # Preview changes
tofu apply     # Apply changes
tofu output    # Show outputs
tofu destroy   # Destroy (careful!)
```

## Next Steps

After cluster is running:
1. Install CNI (Cilium)
2. Install Synology CSI driver
3. Setup GitOps (ArgoCD/Flux)
