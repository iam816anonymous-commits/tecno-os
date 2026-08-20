# IN6-Linux Project Bring-Up Status Matrix (Real Boot Validation Phase)

## Executive Summary
This document tracks the current status of every core milestone and hardware subsystem in the **IN6-Linux** operating system port for the **TECNO IN6 / H633** (MediaTek MT6763 / Helio P23 SoC).

> **STRICT SAFETY POLICY**:
> All build artifacts and scripts enforce non-destructive operations.
> No flashing commands (`fastboot flash`, `erase`, `format`, or block writing) have been executed or embedded in repository scripts.

---

## Bring-Up Status Classification Matrix

| Category / Component | Status Flag | Detail / Evidence Basis |
|---|---|---|
| **HOST BUILD** | **PASS** | `build/verify.sh` compiles DTS, builds initramfs, packages `boot.img`, and passes all host tests. |
| **STRUCTURAL BOOT IMAGE** | **PASS** | `build/artifacts/boot.img` parsed and verified by `tools/boot/inspect_boot.py` as `STRUCTURALLY VALID BOOT IMAGE`. |
| **KERNEL CONFIGURATION** | **CONFIRMED** | Reconstructed in `kernel/configs/in6-stock-defconfig` matching stock `/proc/config.gz` and `tran_in6` flags. |
| **DEVICE TREE** | **CONFIRMED** | Authored `device/tecno/in6/dts/mt6763-tecno-in6.dts` & `.dtsi` with evidence tags (`dtc` compiles with 0 errors). |
| **INITRAMFS** | **CONFIRMED** | Generates `build/artifacts/initramfs.cpio.gz` with diagnostic `/init` shell banner script. |
| **QEMU BOOT** | **NOT APPLICABLE** | Kernel relies on MT6763 SoC IP cores (`topckgen`, `pwrap`, MT6358 PMIC) which lack QEMU machine models. |
| **FASTBOOT CAPABILITY** | **CONFIRMED** | Bootloader state verified: `unlocked: yes`, `secure: no`, `product: IN6_H633`. |
| **TEMPORARY BOOT SUPPORT** | **UNKNOWN** | Requires physical execution test (`fastboot boot build/artifacts/boot.img`). |
| **PHYSICAL KERNEL BOOT** | **NOT TESTED** | Pending manual execution of tethered boot experiment. |
| **INITRAMFS BOOT** | **NOT TESTED** | Pending physical kernel boot execution. |
| **USB/ADB BOOT** | **NOT TESTED** | Pending physical initramfs execution. |
| **DISPLAY** | **UNKNOWN** | MIPI DSI controller defined; specific panel init sequence **UNMEASURED** (`REQUIRES_IN6_MEASUREMENT`). |
| **TOUCH** | **UNKNOWN** | `/dev/input/event2` (`mtk-tpd`) wrapper present; I2C slave address **UNMEASURED** (`REQUIRES_IN6_MEASUREMENT`). |
| **STORAGE** | **CONFIRMED** | eMMC 5.1 (`/dev/block/mmcblk0`) verified via `/proc/partitions` and `mtk-sd` driver. |
| **WIFI** | **LIKELY** | `wlan_drv_gen2.ko` present in stock `/vendor/lib/modules`; requires `WLAN_RAM_CODE_MT6763` firmware binary. |
| **BLUETOOTH** | **LIKELY** | `bt_drv.ko` present in stock `/vendor/lib/modules`; supported by `btmtkuart` driver + `stpbt.bin` firmware. |
| **AUDIO** | **CONFIRMED** | MT6358 internal audio codec & ALSA AFE supported in kernel driver stack. |
| **CAMERA** | **UNKNOWN** | Front & Rear CMOS camera sensor models **UNMEASURED**. |
| **MODEM** | **INFERRED** | MediaTek CCCI baseband modem interface requires `md1img` / `md1dsp` firmware images. |

---

## Exact Unknowns & Blockers

1. **[UNKNOWN] Temporary Boot Protocol Support**: Must test whether the IN6 LK bootloader accepts `fastboot boot`. If unsupported, temporary boot is flagged `UNSUPPORTED` and flashing remains blocked.
2. **[UNKNOWN] Display Panel Init Sequence**: DSI display parameters unextracted due to missing stock `boot.img` dump.
3. **[BLOCKED] Stock Factory Firmware Backup**: No full stock factory ROM package currently in possession. **Flashing internal partitions is strictly prohibited.**
