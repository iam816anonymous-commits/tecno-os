# IN6-Linux Target Hardware Resource Budgets

## Hardware Constraints Baseline
- **Device**: TECNO IN6 / H633
- **SoC**: MediaTek MT6763 (Helio P23) — 8x Cortex-A53
- **RAM**: 3GB LPDDR4X / LPDDR3
- **Storage**: 32GB eMMC 5.1

---

## Resource Budget Allocations

| Resource Domain | System Allocation Target | Hard Limit Threshold | Enforcement Mechanism |
|---|---|---|---|
| **Idle System RAM** | `< 450 MB` | `650 MB` | cgroups v2 memory limits on system services |
| **Idle CPU Utilization** | `< 1.5%` | `5.0%` | Process freezer & suspend on idle |
| **Boot Time (LK to Shell)** | `< 12 seconds` | `20 seconds` | Parallel service startup in init script |
| **System Storage Footprint**| `< 2.5 GB` | `4.0 GB` | Compressed squashfs/ext4 system partition |
| **Idle Battery Drain** | `< 0.8% per hour` | `1.5% per hour` | `mem` deep suspend state |
| **App Startup Latency** | `< 1.2 seconds` | `2.5 seconds` | Pre-linked libraries & GTK4 / Qt6 caching |
