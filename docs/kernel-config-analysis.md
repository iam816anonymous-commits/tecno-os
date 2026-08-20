# IN6-Linux Kernel Configuration Analysis

## Overview
This document analyzes the stock kernel configuration parameters extracted from the TECNO IN6 / H633 running Android 8.1.0 (Linux 4.4.95+, `CONFIG_CUSTOM_TRAN_PROJECT="tran_in6"`).

---

## Key Kernel Options Analysis

### 1. Platform & Transsion Identifiers
- `CONFIG_ARM64=y`: 64-bit ARM architecture.
- `CONFIG_ARCH_MEDIATEK=y`: MediaTek SoC family support.
- `CONFIG_MACH_MT6763=y`: MediaTek MT6763 (Helio P23) target platform.
- `CONFIG_CUSTOM_TRAN_PROJECT="tran_in6"`: Transsion IN6 project board configuration identifier.
- `CONFIG_CUSTOM_TRAN_BOM="tran_in6_a1"`: Transsion IN6 Bill of Materials (BOM) revision a1.

### 2. Multi-Core & Boot Parameters
- `CONFIG_SMP=y`: Symmetric Multi-Processing enabled.
- `CONFIG_NR_CPUS=8`: 8 ARM Cortex-A53 cores.
- `CONFIG_PREEMPT=y`: Low-latency preemptible kernel.
- `CONFIG_OF=y`: Device Tree support enabled.

### 3. Storage & Partition Management
- `CONFIG_MMC=y` / `CONFIG_MMC_MTK=y`: MediaTek eMMC 5.1 host controller driver (`mtk-sd`).
- `CONFIG_EXT4_FS=y`: ext4 support for `/system` and `/vendor`.
- `CONFIG_F2FS_FS=y`: Flash-Friendly File System support for `/data` (`/dev/mmcblk0p33`).

### 4. Serial & Console Output
- `CONFIG_SERIAL_8250=y` / `CONFIG_SERIAL_8250_MT6577=y`: MediaTek 8250-compatible UART controller driver (`uart0` at `0x11002000`).
- `CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7`: Maximum kernel log output for early boot debugging.

### 5. Initramfs & Userspace Boot
- `CONFIG_BLK_DEV_INITRD=y`: Initial RAM disk support enabled.
- `CONFIG_DEVTMPFS=y` / `CONFIG_DEVTMPFS_MOUNT=y`: Automatic mounting of `/dev` virtual filesystem at boot.
