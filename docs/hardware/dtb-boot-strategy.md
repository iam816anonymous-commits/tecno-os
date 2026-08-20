# IN6-Linux Device Tree Binary (DTB) Packaging Strategy

## Overview
This document evaluates the device tree binary (DTB) packaging strategies for passing the compiled `mt6763-tecno-in6.dtb` to the Linux kernel during Little Kernel (LK v0.5) bootloader execution on the **TECNO IN6 / H633**.

---

## Technical Strategy Evaluation

### Strategy A: Appended DTB (`kernel-dtb.bin` Payload)
- **Mechanism**: The compiled DTB binary (`mt6763-tecno-in6.dtb`) is concatenated directly to the gzip-compressed ARM64 kernel (`Image.gz`), producing a single combined payload (`cat Image.gz mt6763-tecno-in6.dtb > kernel-dtb.bin`).
- **Kernel Requirement**: `CONFIG_ARM64_APPENDED_DTB=y` and `CONFIG_ARM64_DTB_512=y` in `in6-stock-defconfig`.
- **Bootloader Requirement**: Standard LK v0.5 bootloader loads `kernel-dtb.bin` to `0x40008000`. The early kernel decompressor scans the payload end for the DTB magic (`0xd00dfeed`) and passes its memory pointer to `setup_arch()`.
- **Status**: **PRIMARY BRING-UP STRATEGY (IMPLEMENTED)**. Matches standard MediaTek Android 4.4 vendor boot packaging.

### Strategy B: Separate Header v2 DTB Payload
- **Mechanism**: The DTB binary is appended after the ramdisk payload with an explicit header size field (Android Header v1/v2).
- **Status**: **SECONDARY STRATEGY**. Requires verification that TECNO IN6 LK v0.5 parses Header v2 `dtb_size` fields.
