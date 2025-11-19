# Talos Linux Installation Guide

Schritt-für-Schritt Anleitung für die Installation von Talos Linux auf ZimaBoard und MINIX mit Tailscale Integration.

## Voraussetzungen

- [x] Talos ISO auf USB-Stick (bereits erstellt)
- [x] Talos Schematic ID generiert: `e2e3b54334c85fdef4d78e88f880d185e0ce0ba0c9b5861bb5daa1cd6574db9b`
- [x] OpenTofu konfiguriert mit Terraform Cloud Backend
- [ ] Tailscale Auth Key generiert und in Bitwarden gespeichert
- [ ] ZimaBoard und MINIX physisch zugänglich

## Schritt 1: Tailscale Auth Key generieren

1. Gehe zu: https://login.tailscale.com/admin/settings/keys
2. Klicke **Generate auth key**
3. Konfiguration:
   - **Description**: `Talos Homelab Cluster`
   - **Reusable**: ✅ Aktiviert (für beide Nodes)
   - **Ephemeral**: ❌ Deaktiviert (Nodes bleiben persistent)
   - **Tags**: `tag:k8s` (optional, für Organization)
   - **Expiry**: 90 Tage

4. Kopiere den Auth Key (beginnt mit `tskey-auth-...`)

5. Speichere in Bitwarden:
   ```
   Name: Tailscale - Talos Auth Key
   Type: Secure Note
   Content: tskey-auth-...
   ```

6. Exportiere lokal als Environment Variable:
   ```bash
   export TF_VAR_tailscale_authkey="tskey-auth-..."
   ```

## Schritt 2: Nodes booten

### ZimaBoard (Control Plane)

1. **USB-Stick einstecken** mit Talos ISO
2. **Boot von USB** (F11 oder BIOS Boot Menu)
3. **Talos startet** - Dashboard zeigt IP-Adresse
4. **Notiere lokale IP** (z.B. `192.168.178.50`)

### MINIX B4 Plus (Worker)

1. **USB-Stick einstecken** mit Talos ISO
2. **Boot von USB** (F11 oder BIOS Boot Menu)
3. **Talos startet** - Dashboard zeigt IP-Adresse
4. **Notiere lokale IP** (z.B. `192.168.178.51`)

## Schritt 3: terraform.tfvars aktualisieren

```bash
cd ~/Repos/homelab/terraform
nano terraform.tfvars
```

Füge die lokalen IPs ein:
```hcl
controlplane_host = "192.168.178.50"  # Deine ZimaBoard IP
worker_host       = "192.168.178.51"  # Deine MINIX IP
```

## Schritt 4: OpenTofu Plan ausführen

```bash
# Stelle sicher, dass Tailscale Auth Key gesetzt ist
export TF_VAR_tailscale_authkey="tskey-auth-..."

# Terraform Cloud Token
export TF_TOKEN_app_terraform_io="<token-aus-bitwarden>"

# Plan erstellen
cd ~/Repos/homelab/terraform
tofu plan
```

Überprüfe den Plan:
- ✅ Custom Installer URL mit Schematic ID
- ✅ Tailscale ExtensionServiceConfig mit Auth Key
- ✅ Beide Nodes werden konfiguriert

## Schritt 5: Cluster installieren

```bash
tofu apply
```

Das wird:
1. Talos Machine Secrets generieren
2. Machine Configs mit Tailscale Extension erstellen
3. Talos auf `/dev/mmcblk0` (ZimaBoard) und `/dev/sda` (MINIX) installieren
4. Control Plane bootstrappen
5. Worker Node joinen
6. Kubernetes Cluster starten

**⏱️ Dauer: ca. 5-10 Minuten**

## Schritt 6: Tailscale Status überprüfen

Nach der Installation:

```bash
# Auf deinem Rechner: Tailscale Status
tailscale status

# Sollte zeigen:
# 100.98.178.59   zimaboard-cp     ...
# 100.98.178.60   minix-worker     ...
```

## Schritt 7: Migration zu Tailscale IPs (optional)

Sobald Nodes in Tailscale sind:

```bash
# terraform.tfvars aktualisieren
controlplane_host = "100.98.178.59"  # Tailscale IP
worker_host       = "100.98.178.60"  # Tailscale IP

# Konfiguration aktualisieren
tofu plan
tofu apply
```

## Schritt 8: Cluster-Zugriff testen

```bash
# Talosconfig exportieren
tofu output -raw talosconfig > ~/.talos/config

# Kubeconfig exportieren
tofu output -raw kubeconfig > ~/.kube/config

# Nodes überprüfen
kubectl get nodes

# Sollte zeigen:
# NAME             STATUS   ROLES           AGE   VERSION
# zimaboard-cp     Ready    control-plane   5m    v1.31.1
# minix-worker     Ready    <none>          5m    v1.31.1
```

## Troubleshooting

### Node nicht erreichbar

```bash
# Ping testen
ping 192.168.178.50

# Talos API testen
talosctl --nodes 192.168.178.50 version
```

### Tailscale Extension nicht aktiv

```bash
# Talos Logs checken
talosctl --nodes 192.168.178.50 logs extensionservice/tailscale

# System Extension Status
talosctl --nodes 192.168.178.50 get extensions
```

### Bootstrap fehlgeschlagen

```bash
# Cluster health
talosctl --nodes 192.168.178.50 health

# Etcd Members
talosctl --nodes 192.168.178.50 etcd members
```

## Nächste Schritte

Nach erfolgreicher Installation:
1. CNI (Cilium) installieren
2. Synology CSI Driver konfigurieren
3. GitOps (ArgoCD/Flux) einrichten
4. GitHub Actions Pipeline aktivieren
