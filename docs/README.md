# Home Server

Personal homelab running on Proxmox with UniFi networking. Built for correctness and rebuildability — everything is documented and version-controlled.

---

## Stack

| Layer | Tech |
|---|---|
| Hypervisor | Proxmox (LXC containers, no VMs) |
| Networking | UniFi — VLAN-segmented |
| Storage | XFS filesystem, bind-mounted into containers |
| IaC | Terraform (`iac/terraform/`) + Ansible (`ansible/`) |

---

## Containers

### Media
| Container | Role |
|---|---|
| Gluetun / qBittorrent / Arr Suite | Secure downloads and media management (Docker, non-root) |
| Jellyfin | Media streaming — bare-metal for GPU passthrough and hardware transcoding |

### Infrastructure
| Container | Role |
|---|---|
| Pi-hole | DNS management, ad-blocking, local DNS routing |
| Nginx Reverse Proxy | SSL termination and traffic routing |

---

## Networking

| VLAN | Purpose |
|---|---|
| 40 | Lab / Proxmox host — hypervisor and management |
| 50 | Media — streaming and media LXCs |
| 60 | Infrastructure — core network services |

---

## Storage Layout

```
/mnt/
├── media/
│   ├── movies/
│   └── tv/
├── downloads/
│   ├── complete/
│   └── incomplete/
└── backups/
    ├── proxmox/
    └── lxc/
```

Storage drive uses XFS. Directories are managed on the Proxmox host and passed into containers via bind-mount points. App data and LXC root disks live on the internal SSD.

---

## Permissions

- Docker services run under a dedicated non-root user (`PUID=1000`, `PGID=1000`)
- Host directory ownership maps to container UID/GID
- Base permissions locked to `755` (least-privilege)

---

## Docs

- [`docs/LOG.md`](docs/LOG.md) — Engineering log: problems, root causes, and fixes
- [`docs/README.md`](docs/README.md) — This file
