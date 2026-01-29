
## 📅 Build Log — 2026-01-28

### Focus
Permissions model, mount validation, and making the environment rebuild-safe.

---

### What I worked on

- Finalized the filesystem permissions model for Docker containers:
  - Confirmed all containers will run as a non-root user (UID/GID 1000).
  - Verified ZFS-mounted directories (e.g. /mnt/appdata) are owned by UID/GID 1000.
  - Confirmed permissions remain 755, relying on ownership (not group/world write) for access.
  - Clarified that containers are treated by the kernel as the file owner, not group or others.

- Identified and corrected historical permission issues:
  - Traced earlier permission problems back to using PUID/PGID = 100.
  - Standardized on UID/GID 1000 across datasets and containers, this ensures containers are owners of ONLY /mnt directories.

- Verified ownership and permissions numerically:
  - Used stat, ls -ln, and id to confirm numeric UID/GID alignment.
  - Confirmed /mnt remains root:root with 755 (unchanged and correct).
  - Confirmed dataset mountpoints (e.g. /mnt/appdata) are owned by UID/GID 1000.
  - Noted presence of ACLs (+) on ZFS datasets and confirmed they are expected.

- Created and finalized rebuild-friendly scripts:
  - Added separate mount verification scripts per VM:
    - verify-mounts-media.sh
    - verify-mounts-infra.sh
  - Finalized fix-permissions-infra.sh:
    - Script changes ownership only (chown), not permissions.
    - Script validates the dataset is mounted before running.
  - Standardized script permissions to 755.

- Clarified scripting philosophy:
  - Scripts are used to reapply known-good state.
  - Documentation remains the primary source of truth.
  - Automation is added only where it's understood.

- Reconfirmed understanding of UniFi behavior:
  - Wired client disconnects are cosmetic and based on inactivity.
  - A systemd timer with a single ICMP ping is a valid, minimal mitigation.
  - This can be scripted for rebuild scenarios.

---

### Current State

- ZFS datasets are correctly mounted and owned.
- Permissions model is fully understood and verified.
- Scripts directory contains only intentional, minimal tooling.
- /mnt parent directory permissions remain unchanged.
- Environment is ready for Docker Compose deployment without permission issues.

---

### Next Steps

- Deploy media services via Docker Compose.
- Validate container UID/GID from inside running containers.
- Document media and infra compose files.
- Continue updating the build log as changes are made.

