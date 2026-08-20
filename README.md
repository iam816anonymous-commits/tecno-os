# IN6-Linux

**Independent Linux OS Port for TECNO IN6 / H633**

## Overview
IN6-Linux is an independent, native Linux operating system project designed specifically for the TECNO IN6 / H633 smartphone based on the MediaTek MT6763 (Helio P23) SoC.

**THIS IS NOT A CUSTOM ROM PROJECT.**
IN6-Linux does not use LineageOS, AOSP, GrapheneOS, or Ubuntu Touch. The project aims for:
- Independent Linux userspace & init/service architecture
- Native Linux kernel (working towards MT6763 mainline)
- IN6-specific hardware bring-up and source-controlled device trees
- Minimal dependence on legacy Android userspace framework
- Fully reproducible builds and automated host validation

## Target Device Specification
- **Device**: TECNO IN6 (Model/HW: H633, Product: IN6_H633)
- **SoC**: MediaTek MT6763V/V (Helio P23) — 8x ARM Cortex-A53 (ARM64 / arm64-v8a)
- **Stock Kernel**: Linux 4.4.95+ (`tran_in6` / `tran_in6_a1`)
- **Bootloader**: Unlocked (unlocked: yes, secure: no)
- **Primary Block Mapping**:
  - `boot`: `/dev/block/mmcblk0p25`
  - `recovery`: `/dev/block/mmcblk0p2`
  - `vendor`: `/dev/block/mmcblk0p30`
  - `system`: `/dev/block/mmcblk0p31`
  - `userdata`: `/dev/block/mmcblk0p33`

## Repository Structure
- `docs/`: Architectural specifications, hardware compatibility matrix, kernel strategy, boot-chain analysis, and research report.
- `inventory/`: Device baseline hardware details extracted from verified device telemetry.
- `kernel/`: Kernel configurations, patch sets, and build helpers.
- `device/tecno/in6/`: DTS/DTSI definitions, firmware manifests, and board configs.
- `userspace/`: Custom init, service manifests, IPC, and mobile shell design.
- `build/`: Reproducible build scripts (`configure.sh`, `build-kernel.sh`, `build-rootfs.sh`, etc.).
- `tools/`: Inventory parsers, DTS helpers, image unpackers/packers.
- `research/`: MediaTek MT6763 comparative analysis against Volla Phone 2020, UMIDIGI Breeze, and postmarketOS.
- `tests/host/`: Automated host-side build and DTS validation checks.

## Safety & Flashing Policy
**Strict Policy**: Development in this repository is non-destructive. Flash commands, partition formatting, or write operations to preloader/lk/nvram are strictly forbidden in automated tool scripts.

## License
Licensed under the [MIT License](LICENSE).
