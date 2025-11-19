# Kubernetes Homelab - Progress Tracker

## 📋 Aktueller Status: **STORAGE SETUP ABGESCHLOSSEN - BEREIT FÜR TALOS LINUX**

### Hardware Inventar
- [x] ZimaBoard (Control Plane) - **Hardware verfügbar, muss eingerichtet werden**
- [x] MINIX B4 Plus (Worker) - **Hardware verfügbar, muss eingerichtet werden**
- [x] Synology NAS - **Verfügbar, Tailscale Setup erforderlich**

### Phase 1: Grundlagen & Planung
- [x] Projektstruktur erstellen
- [x] Hardware-Architektur definieren
- [x] Claude Code Arbeitsweise festlegen
- [ ] Detaillierte Netzwerk-Architektur planen
- [ ] Storage-Strategie definieren
- [ ] Backup-Konzept ausarbeiten

### Phase 2: Netzwerk Vorbereitung
- [x] **Tailscale Setup auf Synology NAS** (IP: 100.98.178.58) ✅
- [ ] Tailscale Setup auf ZimaBoard und MINIX
- [ ] Netzwerk-Segmentierung planen
- [ ] Firewall-Regeln definieren
- [ ] DNS-Konfiguration planen

### Phase 3: Storage Vorbereitung
- [x] **iSCSI Target erstellt** (IQN: iqn.2025-09.homelab.local:k8s-storage)
- [x] **LUNs für Kubernetes erstellt** (1TB + 100GB Volumes verfügbar)
- [x] **iSCSI Konnektivität erfolgreich getestet** (Discovery + Login funktioniert)
- [ ] Storage Classes definieren
- [ ] PV/PVC Strategie planen

### Phase 4: OS Installation
- [x] **USB-Stick mit Talos ISO erstellt** ✅
- [x] **Talos Configs generiert und mit SOPS verschlüsselt** ✅
- [x] **IaC Setup komplett** (Templates, SOPS, .gitignore) ✅
- [ ] Talos Linux auf ZimaBoard installieren
- [ ] Talos Linux auf MINIX installieren
- [ ] Tailscale auf beiden Nodes einrichten
- [ ] Grundkonfiguration testen
- [ ] Netzwerk-Konnektivität prüfen

### Phase 5: Kubernetes Bootstrap
- [ ] Control Plane initialisieren
- [ ] Worker Node joinen
- [ ] CNI Plugin installieren
- [ ] CSI Driver für Synology

### Phase 6: GitOps Setup
- [ ] Git Repository struktur
- [ ] ArgoCD oder Flux installation
- [ ] Basis-Manifeste erstellen
- [ ] Continuous Deployment testen

### Phase 7: Monitoring & Maintenance
- [ ] Prometheus/Grafana Setup
- [ ] Log-Aggregation
- [ ] Alerting konfigurieren
- [ ] Backup-Automatisierung

## 🎯 Nächste Schritte

**Aktueller Fokus:** Talos Linux Installation auf Hardware

### Sofort zu erledigen (nächste Session):
1. **ZimaBoard Hardware Installation** - USB-Stick booten und Talos installieren
2. **MINIX Hardware Installation** - USB-Stick booten und Talos installieren  
3. **Tailscale auf beiden Nodes** einrichten
4. **IPs in Taskfile.yml aktualisieren** und finale Configs generieren

### Geplante Reihenfolge:
**Phase A: OS Installation**
- Talos ISO Download und USB-Stick Vorbereitung
- ZimaBoard: Talos Linux Installation
- MINIX: Talos Linux Installation
- Grundkonfiguration und Netzwerk-Tests

**Phase B: Kubernetes Bootstrap**
- Control Plane auf ZimaBoard initialisieren
- Worker Node (MINIX) joinen
- Synology CSI Driver Setup

### Lernziele dieser Phase:
- Kubernetes Netzwerk-Konzepte verstehen
- Storage-Abstraktion in K8s begreifen  
- Infrastructure-as-Code Prinzipien anwenden

## 📝 Notizen & Erkenntnisse

### Tailscale Setup ✅ ABGESCHLOSSEN
- **NAS IP**: 100.98.178.58 (Konnektivität bestätigt)
- **Status**: `tailscale status` zeigt alle Geräte korrekt
- **Ping Test**: Erfolgreich von NixOS zu NAS

### iSCSI Target Konfiguration ⚠️ PROBLEM IDENTIFIZIERT
- **Target erstellt**: `iqn.2025-09.homelab.local:k8s-storage`
- **CHAP User**: `k8suser` 
- **SAN Manager Status**: "Ready"
- **LUNs**: Dem Target zugewiesen

### ❌ PROBLEM IDENTIFIZIERT: Tailscale Route/Firewall Issue
- **Service Status**: ScsiTarget läuft ✅ 
- **Port Binding**: Bindet an 169.254.247.233:3260 (tun1000) ✅
- **Tailscale IP**: 100.98.178.58 zu tun1000 hinzugefügt ✅
- **Problem**: Connection refused trotz korrektem Setup
- **Root Cause**: Tailscale Routing/Firewall blockiert iSCSI

### ✅ PROBLEM GELÖST: iSCSI Discovery erfolgreich!
- **Lösung**: Tailscale Synology Dokumentation befolgt
- **Reference**: https://tailscale.com/kb/1131/synology
- **Discovery erfolgreich**: 4 IP-Adressen gefunden für Target `iqn.2025-09.homelab.local:k8s-storage`
- **Status**: Bereit für Login und Volume Mount Tests

### 📋 DISCOVERY ERGEBNIS
```
169.254.191.100:3260,1 iqn.2025-09.homelab.local:k8s-storage
[fec0:a2b2:9::764]:3260,1 iqn.2025-09.homelab.local:k8s-storage  
192.168.178.38:3260,1 iqn.2025-09.homelab.local:k8s-storage
100.98.178.58:3260,1 iqn.2025-09.homelab.local:k8s-storage
```

### ✅ FINALE iSCSI TESTS ERFOLGREICH
- **iSCSI Session**: `tcp: [4] 100.98.178.58:3260,1 iqn.2025-09.homelab.local:k8s-storage`
- **Block Devices**: 4 Volumes verfügbar (sdb=1TB, sdc=100GB, sdd=100GB)
- **Status**: Ready for Kubernetes CSI Driver Integration
- **Tailscale Lösung**: https://tailscale.com/kb/1131/synology

### 📊 SESSION ABGESCHLOSSEN (2025-09-08)
**Erreichte Meilensteine:**
- ✅ Synology NAS iSCSI Target vollständig funktionsfähig
- ✅ Tailscale Netzwerk-Konnektivität hergestellt
- ✅ iSCSI Discovery + Login + Block Device Tests erfolgreich
- ✅ Storage-Infrastruktur bereit für Kubernetes Integration

### 📊 SESSION ABGESCHLOSSEN (2025-09-09)
**Erreichte Meilensteine:**
- ✅ **Talos Linux ISO auf USB-Stick geflasht** (metal-amd64.iso)
- ✅ **SOPS + age Verschlüsselung eingerichtet** (Infrastructure as Code)
- ✅ **Talos Machine Configs generiert** (controlplane.yaml, worker.yaml, talosconfig)
- ✅ **Secrets sicher verschlüsselt** (secrets.sops.yaml)
- ✅ **Template-Configs erstellt** (controlplane-template.yaml)
- ✅ **.gitignore konfiguriert** (nur unverschlüsselte Secrets ausgeschlossen)

**Technischer Stack:**
- **SOPS**: Secrets-Management mit age encryption
- **Templates**: Variable substitution für verschiedene Nodes
- **Git-ready**: Alle Configs sicher versioniert

**Nächste Session startet bei:** Talos Linux Hardware Installation (ZimaBoard + MINIX)