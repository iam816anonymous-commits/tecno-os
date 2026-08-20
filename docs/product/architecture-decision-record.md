# IN6-Linux Architecture Decision Records (ADR)

This document records major architectural decisions, technical trade-offs, and alternatives evaluated for **IN6-Linux**.

---

## ADR-001: Independent Linux Userspace vs Android Derived Stack
- **Status**: **ACCEPTED**
- **Context**: Choosing between an Android derivative (AOSP/LineageOS) and an independent native Linux stack.
- **Decision**: Select an independent Linux userspace (`musl`, Wayland, ALSA, PipeWire, NetworkManager).
- **Consequences**: Complete control over system privacy and security; excludes Android Bionic/HAL dependencies as core OS layers.

---

## ADR-002: Phased Kernel Migration Strategy (4.4 Vendor -> 6.1 Mainline)
- **Status**: **ACCEPTED**
- **Context**: Choosing between starting with stock kernel 4.4 vs immediate modern 6.1 LTS kernel.
- **Decision**: Adopt a 2-phase strategy. Phase 1 uses Transsion MT6763 4.4.95 source for initial LK bootloader bring-up. Phase 2 migrates to 6.1 LTS once hardware telemetry is confirmed.
- **Consequences**: Guarantees bootloader handoff success while maintaining a clean upstream migration path.

---

## ADR-003: Centralized IPC Permission Broker below App Layer
- **Status**: **ACCEPTED**
- **Context**: Enforcing granular application capabilities (Camera, Mic, Location, Network).
- **Decision**: Enforce permissions via a system IPC permission broker backed by cgroups v2, AppArmor, and PipeWire client ACLs.
- **Consequences**: Enforces permissions below the application UI; untrusted apps cannot bypass policy.

---

## ADR-004: Wayland Compositor Stack (Wayfire / Weston)
- **Status**: **ACCEPTED**
- **Context**: Selecting display server architecture for mobile UI rendering on ARM Mali-G71 GPU.
- **Decision**: Use lightweight Wayland compositors (Wayfire / Weston) running over DRM/KMS.
- **Consequences**: Low RAM footprint (< 80MB compositor overhead), native touch gesture support, open-source Panfrost GPU driver support.
