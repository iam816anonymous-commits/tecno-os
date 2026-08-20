# IN6-Linux Repository Current State Audit

## Overview
This document presents a comprehensive technical audit of the **IN6-Linux** repository for the **TECNO IN6 / H633** (MediaTek MT6763 / Helio P23) porting project as of Milestone **Real Kernel Bring-Up v0.1**.

Every system parameter, file artifact, and hardware driver is categorized according to strict evidence boundaries:
- **[CONFIRMED]**: Verified by direct telemetry, `/proc/config.gz`, input event dumps, or device properties.
- **[LIKELY]**: Strong technical evidence from MT6763 architecture references and vendor module manifests.
- **[INFERRED]**: Deduced from MediaTek platform conventions and similar MT6763 device trees (Volla Phone 2020 / UMIDIGI Breeze).
- **[UNKNOWN]**: Completely unverified; requires physical bus measurement or kernel log analysis.

---

## 1. Target Hardware & Telemetry Baseline

| Component | Status | Source Evidence | Detail / Parameter |
|---|---|---|---|
| **Device Model** | **[CONFIRMED]** | `getprop`: `ro.product.model` | TECNO IN6 / Model H633 / Product `IN6_H633` |
| **SoC / CPU** | **[CONFIRMED]** | `/proc/cpuinfo` | MediaTek MT6763V/V (8x Cortex-A53 @ ARM64 / arm64-v8a) |
| **Stock OS & SDK** | **[CONFIRMED]** | `getprop`: `ro.build.version.release` | Android 8.1.0 (API Level 27, Treble Enabled) |
| **Stock Kernel Version** | **[CONFIRMED]** | `uname -a` | Linux 4.4.95+ `#2` SMP PREEMPT (GCC 6.3.1 / Linaro 2017.02) |
| **Vendor Kernel Flags** | **[CONFIRMED]** | `/proc/config.gz` | `CONFIG_CUSTOM_TRAN_PROJECT="tran_in6"`, `CONFIG_CUSTOM_TRAN_BOM="tran_in6_a1"` |
| **Bootloader State** | **[CONFIRMED]** | `fastboot getvar` | `unlocked: yes`, `secure: no`, `product: IN6_H633`, LK bootloader |
| **Partition Scheme** | **[CONFIRMED]** | Android partition mapping | Non-A/B traditional layout (`mmcblk0p25`: boot, `mmcblk0p2`: recovery, `mmcblk0p31`: system, `mmcblk0p30`: vendor, `mmcblk0p33`: userdata) |
| **Stock Boot Image** | **[CONFIRMED ABSENT]** | ADB shell constraint | ADB shell is `uid=2000` (no root); previous `boot.img` dumps are 64-byte invalid files. **No valid stock boot.img exists in repository.** |
| **Vendor Modules** | **[CONFIRMED]** | `/vendor/lib/modules` | `wmt_drv.ko`, `wlan_drv_gen2.ko`, `bt_drv.ko`, `gps_drv.ko`, `fmradio_drv.ko`, `wmt_chrdev_wifi.ko`, `met.ko` |
| **Input Event Devices** | **[CONFIRMED]** | `/proc/bus/input/devices` | `event0` (`mtk-kpd`), `event1` (`pmic_keys`), `event2` (`mtk-tpd`), `event3` (`headset-keyboard`) |
| **PMIC Architecture** | **[LIKELY]** | MT6763 Platform Ref | MediaTek MT6358 / MT6357 PMIC via PMIC Wrapper (`pwrap`) |
| **Display Panel IC** | **[UNKNOWN]** | None | MIPI DSI LCD panel — specific controller IC & init sequence **UNKNOWN** |
| **Touchscreen IC** | **[UNKNOWN]** | None | `/dev/input/event2` (`mtk-tpd`) wrapper present; I2C slave address & IC **UNKNOWN** |
| **Sensors** | **[UNKNOWN]** | None | Accelerometer, Gyroscope, Magnetometer, Proximity, Light IC models **UNKNOWN** |
| **Camera Sensors** | **[UNKNOWN]** | None | Front & Rear camera CMOS sensors **UNKNOWN** |

---

## 2. Repository Infrastructure & Build System Audit

- **Device Tree**: `device/tecno/in6/dts/mt6763-tecno-in6.dts` and `.dtsi` exist and compile cleanly with `dtc`. Unverified properties are annotated with `REQUIRES_IN6_MEASUREMENT` and `TODO_UNKNOWN`.
- **Build Tooling**: `build/configure.sh`, `build-kernel.sh`, `build-rootfs.sh`, `build-image.sh`, `clean.sh`, `verify.sh`, and `build.ps1` form an automated build pipeline.
- **Safety Enforcement**: Non-flashing guardrails are enforced. All scripts strictly avoid `fastboot flash`, `erase`, `format`, or block writing.
- **Host Testing**: Automated tests (`tests/host/`) validate inventory completeness, DTS syntax, and flashing safety.
