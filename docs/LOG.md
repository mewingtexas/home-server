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

