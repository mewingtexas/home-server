
### Issues & Fixes

# 1/28/2026

## UniFi "wired client disconnected" 

## UniFi wired client disconnects (cosmetic)

**Cause**
UniFi determines wired client presence by observed traffic.
Idle Linux VMs may appear disconnected.

**Fix**
Use a systemd timer to send a single ICMP ping every 5 minutes.

**Script**
`scripts/unifi-keepalive-timer.sh`
