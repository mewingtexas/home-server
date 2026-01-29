# 🏠 Home Server Architecture

This repository documents the design, setup, and ongoing build of my home server environment.
The focus is on documentation, rebuildability, and understanding rather than one-off configurations.

This repo serves as:
- A source of truth for architectural decisions
- A rebuild guide for virtual machines
- A learning log capturing problems, root causes, and fixes

---

## 🧱 Overview

- **Hypervisor:** Proxmox
- **Virtual Envionrments:** 1 VM running docker compose || multiple lxc containers
- **Networking:** UniFi with segmented VLANs
- **Storage:** 2 ZFS HDDs running raid
- **Services:** Docker-based, non-root containers
- **Design philosophy:** correctness first, automation second

---

## 🖥️ Virtual Machines

### Media VM
**Purpose**
- Run all media-related services in a centralized area
- Isolated from infrastructure services

**Media Stack**
- Gluetun (VPN)
- qBittorrent
- Jellyfin
- Sonarr
- Radarr
- Prowlarr

### Infrastructure (LXCs)
**Purpose:**
- Core network and access services
- Lightweight, stable, low churn
- Minimal overhead using Linux Containers instead of full VMs

**Infra Stack**
- Grafana Monitoring
- PiHole DNS
- Nginx Reverse Proxy

##  Storage / What This Environment Consumes

### Internal SSD (Host + VM OS + Appdata)
- **Purpose:** Simplicity, low latency, fewer failure points
- **Usage:**
  - Proxmox host operating system
  - Virtual machine OS disks
  - Container application data (`/mnt/appdata` inside the VM)

---

### HDD Storage (ZFS — Media & Downloads, RAID)
- **Purpose:** Capacity, data integrity, redundancy, and long-term retention
- **Filesystem:** ZFS
- **RAID Model:** ZFS mirror (planned second HDD)
- **Usage:**
  - Media libraries (movies, TV, anime)
  - Download staging (complete / incomplete)
  - On-host backups (VMs, LXCs, and configuration data)
- **Why ZFS + RAID here:**
  - End-to-end checksumming for data integrity
  - Redundancy via mirrored disks to tolerate single-drive failure
  - Compression for space efficiency
  - Dataset-level snapshots and retention policies
  - Clear separation of concerns between media, transient downloads, and backups
  - Straightforward expansion as additional drives are added to terramaster DAS

### Dataset layout

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

## 🌐 Networking Design

### VLAN Segmentation

The network is segmented to separate concerns and simplify troubleshooting.

| VLAN | Purpose               | Notes                          |
|------|-----------------------|--------------------------------|
| 40   | Lab / Proxmox Host    | Hypervisor and management      |
| 50   | Media                 | Media VM and services          |
| 60   | Infrastructure        | Infra and core services        |


**Benefits**
- Clear separation of duties
- Easier troubleshooting
- Reduced blast radius for issues

---
## 🔐 Permissions Model

### Non-root Containers
All Docker containers run as a **non-root user**.

- Containers use `PUID=1000`
- Containers use `PGID=1000`
- UID/GID 1000 corresponds to the primary Ubuntu user

---

### Ownership Strategy
- ZFS dataset mountpoints are owned by `UID:GID 1000:1000`
- Directory permissions remain `755`
- Containers are treated as **file owners**, not group or others

This provides:
- Write access where intended
- No need for root containers
- Least-privilege security model

---

### Important Clarification
- Ownership (`chown`) enables write access
- Permissions (`chmod`) remain restrictive
- `/mnt` itself remains `root:root` with `755`
- Only dataset mountpoints are modified

---

## 🧪 Scripts

Scripts are intentionally minimal and focused on the Media VM only (for now)

### Media VM scripts
- **Mount verification (media only):**
  - Verifies `/mnt/downloads` and `/mnt/media` are mounted before starting Docker
- **Permissions alignment (media only):**
  - Ensures `/mnt/appdata`, `/mnt/downloads`, and `/mnt/media` are owned by `1000:1000`

### Infra scripts
- Infra is LXCs; no Docker mount-check or PUID/PGID scripts are required there.

---

## 📚 Documentation Philosophy

This repository evolves over time.

- Problems are documented as they occur
- Root causes are identified before fixes are scripted
- Automation is added only after repetition

---

## 📝 Documentation Structure

- `docs/BUILD_LOG.md` — chronological progress
- `docs/ISSUES.md` — problems, causes, and fixes
- `docs/TODAY.md` — daily planning and focus

---

## 🚧 Current Status

- Storage layout finalized
- Networking segmented and stable
- Appdata mounted via Virtio-FS
- Permissions model verified numerically
- Scripted rebuild steps established
- Repository structure in place

---

## 📌 Rebuild Philosophy

This environment is designed to be:
- Understandable
- Rebuildable
- Incrementally automated

Manual steps come first.
Automation follows only when repetition proves it necessary.


