# IN6-Linux Project Bring-Up Status Matrix (Phase 3 Real Hardware Bring-Up)

## Executive Summary
This document tracks the current status of every core milestone and hardware subsystem in the **IN6-Linux** operating system port for the **TECNO IN6 / H633** (MediaTek MT6763 / Helio P23 SoC).

> **STRICT SAFETY POLICY**:
> All build artifacts and scripts enforce non-destructive operations.
> No flashing commands (`fastboot flash`, `erase`, `format`, or block writing) have been executed or embedded in repository scripts.

---

## Bring-Up Status Classification Matrix

| Category / Component | Host Status | Device Status | Evidence Basis |
|---|---|---|---|
| **HOST BUILD** | **PASS** | N/A | `build/verify.sh` compiles DTS, builds initramfs, packages `boot.img`, and passes all host tests. |
| **STRUCTURAL BOOT IMAGE** | **PASS** | N/A | `build/artifacts/boot.img` parsed and verified by `tools/boot/inspect_boot.py` as `STRUCTURALLY VALID BOOT IMAGE`. |
| **KERNEL CONFIGURATION** | **CONFIRMED** | N/A | Reconstructed in `kernel/configs/in6-stock-defconfig` matching stock `/proc/config.gz` and `tran_in6` flags. |
| **DEVICE TREE** | **CONFIRMED** | N/A | Authored `device/tecno/in6/dts/mt6763-tecno-in6.dts` & `.dtsi` with evidence tags (`dtc` compiles with 0 errors). |
| **INITRAMFS** | **CONFIRMED** | N/A | Generates `build/artifacts/initramfs.cpio.gz` with diagnostic `#!/bin/sh` `/init` banner script. |
| **QEMU BOOT** | **NOT APPLICABLE**| N/A | Kernel relies on MT6763 SoC IP cores (`topckgen`, `pwrap`, MT6358 PMIC) which lack QEMU machine models. |
| **FASTBOOT CAPABILITY** | **CONFIRMED** | **CONFIRMED** | Bootloader state verified: `unlocked: yes`, `secure: no`, `product: IN6_H633`. |
| **TEMPORARY BOOT SUPPORT** | **CONFIRMED** | **UNKNOWN** | Requires physical execution test (`fastboot boot build/artifacts/boot.img`). |
| **PHYSICAL KERNEL BOOT** | **CONFIRMED** | **NO** | **NO — Pending physical tethered boot experiment.** |
| **INITRAMFS BOOT** | **CONFIRMED** | **NO** | Pending physical kernel execution. |
| **USB/ADB BOOT** | **CONFIRMED** | **NO** | Pending physical initramfs execution. |
| **DISPLAY** | **INFERRED** | **UNKNOWN** | MIPI DSI controller defined; specific panel init sequence **UNMEASURED** (`REQUIRES_IN6_MEASUREMENT`). |
| **TOUCH** | **INFERRED** | **UNKNOWN** | `/dev/input/event2` (`mtk-tpd`) wrapper present; I2C slave address **UNMEASURED** (`REQUIRES_IN6_MEASUREMENT`). |
| **STORAGE** | **CONFIRMED** | **CONFIRMED** | eMMC 5.1 (`/dev/block/mmcblk0`) verified via `/proc/partitions` and `mtk-sd` driver. |
| **WIFI** | **LIKELY** | **UNKNOWN** | `wlan_drv_gen2.ko` present in stock `/vendor/lib/modules`; requires `WLAN_RAM_CODE_MT6763` firmware binary. |
| **BLUETOOTH** | **LIKELY** | **UNKNOWN** | `bt_drv.ko` present in stock `/vendor/lib/modules`; supported by `btmtkuart` driver + `stpbt.bin` firmware. |
| **AUDIO** | **CONFIRMED** | **UNKNOWN** | MT6358 internal audio codec & ALSA AFE supported in kernel driver stack. |
| **CAMERA** | **UNKNOWN** | **UNKNOWN** | Front & Rear CMOS camera sensor models **UNMEASURED**. |
| **MODEM** | **INFERRED** | **UNKNOWN** | MediaTek CCCI baseband modem interface requires `md1img` / `md1dsp` firmware images. |

---

## Physical Hardware Execution Answer

> **HAS OUR KERNEL ACTUALLY EXECUTED ON THE TECNO IN6?**
>
> **ANSWER**: **NO — Pending physical tethered boot experiment.**
>
> The candidate kernel and `boot.img` artifacts are 100% verified structurally on the host, but physical execution telemetry on the actual TECNO IN6 smartphone has not yet been performed.

---

## Exact Unknowns & Blockers

1. **[UNKNOWN] Temporary Boot Protocol Support**: Must test whether the IN6 LK bootloader accepts `fastboot boot`. If unsupported, temporary boot is flagged `UNSUPPORTED` and flashing remains blocked.
2. **[UNKNOWN] Display Panel Init Sequence**: DSI display parameters unextracted due to missing stock `boot.img` dump.
3. **[BLOCKED] Stock Factory Firmware Backup**: No full stock factory ROM package currently in possession. **Flashing internal partitions is strictly prohibited.**
