# Log

---

## 2026-01-28

- Finalized filesystem permissions for Docker containers: Non-root user (UID/GID 1000), ZFS-mounted directories owned by 1000:1000, permissions 755.
- Corrected historical issues: Standardized UID/GID 1000, ensuring containers own /mnt directories.
- Verified ownership numerically: Used stat, ls -ln, id; confirmed /mnt root:root 755, mountpoints 1000:1000, ACLs expected.
- Created rebuild scripts: verify-mounts-media.sh, verify-mounts-infra.sh, fix-permissions-infra.sh (chown only, validates mount).
- Standardized script permissions to 755.
- Clarified scripting: Reapply known-good state, documentation primary, automation when understood.
- Reconfirmed UniFi: Wired disconnects cosmetic; systemd timer with ICMP ping as mitigation.

---

## 2026-02-18

- Started Terraform → Proxmox integration (no LXCs provisioned yet).
- Actions taken:
  - Created `iac/terraform` working directory and modular files: `providers.tf`, `variables.tf`, `terraform.tfvars`, `lxcs.tf`, `outputs.tf`.
  - Secured sensitive files in `.gitignore`: `terraform.tfvars`, `*.tfstate`, `.terraform/`.
  - Defined Proxmox variables: `proxmox_api_url` and sensitive `proxmox_api_token`; supplied values in `terraform.tfvars` (kept untracked).
  - Selected and configured `bpg/proxmox` provider (endpoint, `api_token`, `insecure = true`).
  - Initialized Terraform (`terraform init`) and verified provider installation (`terraform providers`, `.terraform.lock.hcl`).
  - Designed LXC schema as `map(object(...))` to enable `for_each` provisioning; separated blueprint logic (lxcs.tf) from instance data (tfvars).
  - Clarified outputs: expose post-provision attributes (IPs, resources) as live documentation.
- Next: provision LXCs for Pi-hole, Nginx, and Grafana when ready.

---

## 2026-03-11 

- Provisioned first IaC-managed LXCs via Terraform: Pi-hole (VM ID 200) and Prometheus (VM ID 201).
- Actions taken:
  - Revised `variables.tf`: replaced single `lxc_password` with per-container password variables (`pihole_password`, `prometheus_password`); renamed `debian_template` to per-container template variables (`pihole_template`, `prometheus_template`) to allow different distros per container in future.
  - Built `main.tf` with two `proxmox_virtual_environment_container` resources using `bpg/proxmox` provider.
  - Pi-hole: 1 core, 512MB RAM, 8GB disk, `nesting = true` (required for `systemd-resolved`), static IP `192.168.60.10/24`, VLAN 60.
  - Prometheus: 2 cores, 1024MB RAM, 16GB disk, `nesting = false`, static IP `192.168.60.20/24`, VLAN 60.
  - Both containers: Debian 12, `vmbr0` bridge, `unprivileged = true`, started on apply.
  - Confirmed `terraform.tfstate` and `terraform.tfstate.backup` added to `.gitignore` to prevent secrets leaking via state file.
  - Ran `terraform init` → `terraform plan` → `terraform apply`; both containers confirmed live in Proxmox.
- Architecture decisions:
  - Skipped Grafana for now — Grafana without a data source (Prometheus) has no value; deploying Prometheus first is the correct order.
  - Skipped Nginx reverse proxy — not needed until service count grows or external access is required.
  - Prometheus chosen over InfluxDB for metrics storage; will feed from node exporters, Pi-hole exporter, UniFi Poller, ZFS exporter, cAdvisor, and native endpoints on Sonarr/Radarr/Prowlarr/Jellyfin.
- Next: SSH into containers, install services manually, then revisit Ansible for configuration automation.

