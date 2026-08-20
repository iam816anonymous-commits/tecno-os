# IN6-Linux Kernel & Device Tree Self-Consistency Audit

## Overview
This document evaluates the cross-component compatibility between the kernel configuration (`kernel/configs/in6-stock-defconfig`), compiled kernel image (`build/artifacts/Image.gz`), compiled device tree binary (`build/artifacts/mt6763-tecno-in6.dtb`), and root filesystem initramfs (`build/artifacts/initramfs.cpio.gz`).

---

## Cross-Component Consistency Audit Matrix

| Subsystem Requirement | Kernel Config Flag (`in6-stock-defconfig`) | Device Tree Node (`mt6763-tecno-in6.dts`) | Initramfs / Userspace Requirement | Status & Compatibility | Evidence Classification |
|---|---|---|---|---|---|
| **Architecture Target** | `CONFIG_ARM64=y`, `CONFIG_64BIT=y` | `#address-cells = <2>; #size-cells = <2>;` | ARM64 ELF binaries (`aarch64`) | **MATCHED** | **[CONFIRMED]** |
| **SoC Platform Target** | `CONFIG_ARCH_MEDIATEK=y`, `CONFIG_MACH_MT6763=y` | `compatible = "tecno,in6", "mediatek,mt6763";` | Platform identification strings | **MATCHED** | **[CONFIRMED]** |
| **Early Console Output** | `CONFIG_SERIAL_8250=y`, `CONFIG_SERIAL_8250_MT6577=y` | `uart0: serial@11002000` | `earlycon=uart8250,mmio32,0x11002000` | **MATCHED** | **[CONFIRMED]** |
| **eMMC Storage Support** | `CONFIG_MMC=y`, `CONFIG_MMC_MTK=y` | `mmc0: mmc@11230000` | `/dev/mmcblk0p33` root mount capability | **MATCHED** | **[CONFIRMED]** |
| **Device Tree Driver** | `CONFIG_OF=y`, `CONFIG_OF_FLATTREE=y` | `/dts-v1/;` binary DTB structure | dtb payload passed at ATAGS/tags addr | **MATCHED** | **[CONFIRMED]** |
| **Initramfs Execution** | `CONFIG_BLK_DEV_INITRD=y`, `CONFIG_RD_GZIP=y` | `chosen` bootargs `init=/init` | Gzip-compressed cpio archive containing `/init` | **MATCHED** | **[CONFIRMED]** |
| **Devtmpfs Auto-Mount** | `CONFIG_DEVTMPFS=y`, `CONFIG_DEVTMPFS_MOUNT=y` | Standard virtual filesystem nodes | Mounts `/dev` automatically at early boot | **MATCHED** | **[CONFIRMED]** |
| **Filesystems (Root/Data)**| `CONFIG_EXT4_FS=y`, `CONFIG_F2FS_FS=y` | Root partition mapping (`mmcblk0p33`) | Support for ext4 system and f2fs userdata | **MATCHED** | **[CONFIRMED]** |
| **Keypad Input Drivers** | `CONFIG_KEYBOARD_MTK=y`, `CONFIG_KEYBOARD_GPIO=y` | `gpio-keys` (`Volume Up`/`Down` nodes) | `/dev/input/event0` event processing | **MATCHED** | **[CONFIRMED]** |

---

## Strict Hardware Guardrail Compliance
- **No Speculative Drivers Enabled**: Drivers for unverified peripherals (e.g., custom sensor chips, specific camera ICs, or external charger chips) are **NOT** enabled in `in6-stock-defconfig`.
- **Evidence Tag Integrity Maintained**: Unmeasured board properties in DTS remain explicitly tagged as `REQUIRES_IN6_MEASUREMENT` or `TODO_UNKNOWN`.
