# IN6-Linux System & Component Requirements Specification

## Overview
This document specifies the core system and functional requirements across twenty operational domains for **IN6-Linux** on the **TECNO IN6 / H633** (MediaTek MT6763).

---

## Twenty Core Requirement Domains

### 1. Boot System & Handoff
- Must boot from unlocked MediaTek LK bootloader using standard Android Header v0 `boot.img`.
- Must parse device tree binary (`mt6763-tecno-in6.dtb`) and mount root filesystem cleanly.

### 2. Kernel & Drivers
- Must maintain a 64-bit ARM64 Linux kernel with native driver support for MT6763 peripherals.
- Must provide early console output via UART0 (`0x11002000`) or USB CDC ACM gadget.

### 3. Init & Process Supervision
- Must execute a lightweight, non-monolithic init system (s6 / runit / musl-init).
- Must supervise background services and enforce resource limits.

### 4. Hardware Isolation & Abstraction
- Must isolate hardware-specific drivers into clean abstraction services (`/hardware/`).
- Must prevent unprivileged applications from directly accessing raw block devices or kernel memory.

### 5. Memory & Storage Management
- Must operate within 3GB LPDDR RAM budget (idle OS RAM footprint < 450 MB).
- Must mount ext4 system partitions and f2fs userdata partitions (`/dev/mmcblk0p33`).

### 6. Display & Touch Subsystem
- Must drive MIPI DSI display via DRM/KMS (`/dev/dri/card0`).
- Must process touch input events via evdev interface (`/dev/input/event2`).

### 7. Audio & Media Routing
- Must manage MT6358 internal codec via ALSA and PipeWire / WirePlumber.
- Must route audio dynamically to Speaker, Earpiece, and 3.5mm Headphone Jack.

### 8. Input & Keypad Event Handling
- Must process hardware keys (Volume Up, Volume Down, Power Key) via `gpio-keys` and `pmic_keys`.

### 9. Power & Battery Management
- Must support system suspend/resume and CPU frequency scaling (`cpufreq`).
- Must monitor MT6358 battery charge state and thermal throttling limits.

### 10. Peripheral Connectivity (USB/OTG)
- Must support USB High-Speed CDC ACM serial gadget, MTP file transfer, and USB OTG host mode.

### 11. Wireless Subsystem (Wi-Fi/Bluetooth/FM/GPS)
- Must load MT6631 proprietary firmware binaries safely to enable Wi-Fi and Bluetooth.

### 12. Cellular Modem Subsystem
- Must interface with MT6763 baseband modem via CCCI driver for voice calls, SMS, and mobile data.

### 13. Camera & Flash Subsystem
- Must expose MIPI CSI camera sensors via V4L2 subdev interfaces and ISP 3.0 pipeline.

### 14. Sensor Subsystem (IIO)
- Must expose accelerometer, gyroscope, magnetometer, light, and proximity sensors via Linux IIO drivers.

### 15. Security & Sandboxing Framework
- Must isolate third-party applications using Linux Namespaces, cgroups, seccomp, and AppArmor.

### 16. Granular Permission Broker
- Must enforce per-application capabilities (Camera, Mic, Location, Contacts, SMS, Network) via centralized IPC broker.

### 17. Per-App Network Firewall
- Must enforce per-app network isolation rules (Allow, Deny, Wi-Fi only, Cellular only, Local only).

### 18. Mobile UI & Compositor
- Must run a lightweight Wayland compositor (Wayfire / Phosh / Weston) optimized for touch.

### 19. Offline Package Manager
- Must support local offline package installation, dependency resolution, and rollback.

### 20. Privacy & Security Dashboards
- Must expose real-time permission activity, network toggles, and system security status.
