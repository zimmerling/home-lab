Kubernetes Homelab Infrastructure Plan - Lernorientierter Guide
Wichtiger Hinweis für Claude Code Integration
🎯 Lernziel: Dieses Projekt dient dem Erlernen von Kubernetes, Infrastructure as Code und DevOps Praktiken.
Claude Code Rolle:

❌ KEINE automatischen Implementierungen oder fertigen Lösungen
❌ KEINE direkten Code-Änderungen ohne explizite Anfrage
✅ NUR Vorschläge und Empfehlungen geben
✅ Fortschritt tracken durch Abhaken erledigter Aufgaben
✅ Bei Problemen helfen und Debugging unterstützen
✅ Best Practices erklären und alternative Ansätze vorschlagen

Arbeitsweise: Jede Phase enthält Lernaufgaben, die selbständig bearbeitet werden sollen. Claude Code soll nur beraten und den aktuellen Status verfolgen.
Projektübersicht
Aufbau eines ausfallsicheren Infrastructure-as-Code Kubernetes Heimclusters mit:

ZimaBoard als Control Plane (4GB RAM, 16GB Storage)
MINIX B4 Plus als Worker Node (16GB RAM, 512GB Storage)
Synology NAS als Persistent Storage über iSCSI
Umfassende Backup-Strategie für Zero-Data-Loss
Wartungsfreundliche GitOps Architektur

Hardware Setup (Revidiert)
Node 1: ZimaBoard (Control Plane)

CPU: Intel Celeron N3350 Dual-Core
RAM: 4GB (ausreichend für Control Plane bei kleinem Cluster)
Storage: 16GB eMMC (nur für Talos OS)
Rolle: Control Plane Node (etcd, API Server, Scheduler, Controller Manager)
Besonderheiten: Niedriger Stromverbrauch, kompakte Bauform

Node 2: MINIX B4 Plus (Worker)

CPU: Intel Processor
RAM: 16GB (ideal für Workloads)
Storage: 512GB (für Container Images, temporäre Daten)
Rolle: Worker Node (läuft alle Anwendungs-Pods)
Besonderheiten: Mehr Ressourcen für rechenintensive Workloads

Storage: Synology NAS

Kapazität: 2x 4TB in RAID 1 (3.6TB nutzbar)
Protokoll: iSCSI (über Tailscale vernetzt)
Funktion: Persistent Volumes, Backups, Container Registry
CSI Driver: Synology CSI für automatische Volume Erstellung

Warum diese Aufteilung?
Control Plane auf ZimaBoard:

Control Plane braucht weniger RAM als Worker Nodes
Konstante, aber niedrige CPU Last
Weniger Storage-Bedarf (nur etcd Datenbank)
24/7 Laufzeit bei niedrigem Stromverbrauch

Worker auf MINIX:

Mehr RAM für Anwendungs-Pods verfügbar
Bessere Performance für Container Workloads
Lokaler Storage für Cache und temporäre Daten

Detaillierte Netzwerk Architektur
Physische Netzwerke

