# Home Server Architecture

This repository documents the design, setup, and ongoing build of my home server environment. The focus is on documentation, rebuildability, and understanding rather than one-off configurations.

This repo serves as:
- A source of truth for architectural decisions
- A rebuild guide for virtual machines
- A learning log capturing problems, root causes, and fixes

---

## Overview

- **Hypervisor:** Proxmox
- **Virtual Environments:** 1 VM running Docker Compose || multiple LXC containers
- **Networking:** UniFi with segmented VLANs
- **Storage:** 2 ZFS HDDs in RAID
- **Services:** Docker-based, non-root containers
- **Design Philosophy:** Correctness first, automation second

---

## Virtual Machines

### Media VM
**Purpose:** Run all media-related services in a centralized, isolated area.

**Media Stack:**
- Gluetun (VPN)
- qBittorrent
- Jellyfin
- Sonarr
- Radarr
- Prowlarr

### Infrastructure (LXCs)
**Purpose:** Core network and access services, lightweight and stable.

**Infra Stack:**
- Grafana Monitoring
- PiHole DNS
- Nginx Reverse Proxy

---

## Storage

### Internal SSD (Host + VM OS + Appdata)
- **Purpose:** Simplicity, low latency, fewer failure points
- **Usage:** Proxmox host OS, VM OS disks, container app data (`/mnt/appdata`)

### HDD Storage (ZFS — Media & Downloads, RAID)
- **Purpose:** Capacity, data integrity, redundancy, long-term retention
- **Filesystem:** ZFS
- **RAID Model:** ZFS mirror (planned second HDD)
- **Usage:** Media libraries, download staging, on-host backups
- **Why ZFS + RAID:** End-to-end checksumming, redundancy, compression, snapshots, dataset-level retention

### Dataset Layout
```
HDD-pool/
├── media/
│   ├── movies/
│   └── tv/
├── downloads/
│   ├── complete/
│   └── incomplete/
└── backups/
    ├── proxmox/
    ├── media-vm/
    └── infra/
```

---

## Networking Design

### VLAN Segmentation
The network is segmented for separation of concerns and easier troubleshooting.

| VLAN | Purpose               | Notes                          |
|------|-----------------------|--------------------------------|
| 40   | Lab / Proxmox Host    | Hypervisor and management      |
| 50   | Media                 | Media VM and services          |
| 60   | Infrastructure        | Infra and core services        |

**Benefits:** Clear separation, easier troubleshooting, reduced blast radius.

---

## Permissions Model

### Non-root Containers
All Docker containers run as non-root user (PUID=1000, PGID=1000, corresponding to primary Ubuntu user).

### Ownership Strategy
- ZFS dataset mountpoints owned by `1000:1000`
- Directory permissions: `755`
- Containers as file owners for least-privilege security.

**Clarification:** Ownership enables write access; permissions remain restrictive. `/mnt` is `root:root` with `755`; only mountpoints modified.

---

## Scripts

Scripts are minimal, focused on Media VM.

- **Mount verification (media only):** Verifies `/mnt/downloads` and `/mnt/media` mounted before Docker starts.
- **Permissions alignment (media only):** Ensures `/mnt/appdata`, `/mnt/downloads`, `/mnt/media` owned by `1000:1000`.
- Infra LXCs: No Docker scripts needed.

---

## Infrastructure as Code

### Terraform
Infrastructure provisioning and management is handled via Terraform. Configurations are located in `iac/terraform/`, including main.tf, variables.tf, and terraform.tfvars. This ensures reproducible and version-controlled infrastructure setup.

### Ansible
Planned for configuration management and automation of server setups, playbooks, and roles. Will be added to `iac/ansible/` for automating software installation, configuration, and maintenance tasks.

---

## Documentation Philosophy

This repository evolves over time. Problems are documented as they occur, root causes identified before fixes, automation added only after repetition.

---

## Documentation Structure

- `docs/BUILD_LOG.md` — Chronological progression

---

## Rebuild Philosophy

Designed to be understandable, rebuildable, incrementally automated. Manual steps first; automation follows repetition.

