# IN6-Linux Per-Application Network Isolation Architecture

## Overview
IN6-Linux implements per-application network isolation using Linux Network Namespaces (`netns`), cgroups v2 `net_cls`/cgroup socket matching, and `nftables` / `iptables` packet filtering rules.

---

## Network Isolation Modes

Users can assign one of six network access policies to any application:
1. **FULL ACCESS**: Unrestricted network communication.
2. **DENIED (OFFLINE)**: All outbound and inbound network sockets are dropped at the kernel boundary.
3. **WI-FI ONLY**: Network sockets are bound exclusively to the `wlan0` interface; traffic routed over cellular data (`ccmni0`) is blocked.
4. **CELLULAR ONLY**: Network sockets are bound exclusively to the cellular modem interface (`ccmni0`); traffic over `wlan0` is blocked.
5. **LOCAL NETWORK ONLY**: Communication is restricted to local subnet IP ranges (`192.168.0.0/16`, `10.0.0.0/8`); WAN traffic is dropped.
6. **COMPLETELY OFFLINE**: Application process is spawned inside an isolated Network Namespace without a loopback or virtual Ethernet device.

---

## Persistence & Reboot Survival
Network isolation rules are recorded in `/etc/in6-network-policy.json` and restored by the network manager daemon during early boot before any user application is spawned.
