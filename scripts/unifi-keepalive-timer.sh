#!/usr/bin/env bash
set -euo pipefail

# Purpose: Keep UniFi from marking an idle wired VM as "disconnected" (cosmetic).
# Approach: Install a systemd timer that runs ONE ping on a schedule.
#
# Edit TARGET to your gateway or another always-on IP in the same VLAN.
TARGET="${TARGET:-192.168.50.1}"

SERVICE_NAME="unifi-keepalive"
SERVICE_PATH="/etc/systemd/system/${SERVICE_NAME}.service"
TIMER_PATH="/etc/systemd/system/${SERVICE_NAME}.timer"

if [[ $EUID -ne 0 ]]; then
  echo "Run as root: sudo $0"
  exit 1
fi

cat > "$SERVICE_PATH" <<EOF
[Unit]
Description=UniFi keepalive: send one ICMP ping to maintain wired client presence

[Service]
Type=oneshot
ExecStart=/bin/ping -c 1 -W 1 ${TARGET}
TimeoutStartSec=3
EOF

cat > "$TIMER_PATH" <<'EOF'
[Unit]
Description=Run UniFi keepalive ping periodically

[Timer]
OnBootSec=2min
OnUnitActiveSec=5min
AccuracySec=1min

[Install]
WantedBy=timers.target
EOF

systemctl daemon-reload
systemctl enable --now "${SERVICE_NAME}.timer"

echo "Installed: ${SERVICE_NAME}.timer -> pings ${TARGET} once every 5 minutes"
echo "Check: systemctl list-timers | grep ${SERVICE_NAME}"
