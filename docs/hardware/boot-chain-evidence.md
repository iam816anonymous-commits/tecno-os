# MediaTek LK v0.5 Boot Chain Evidence & Binary Specifications

## Overview
This document records verified evidence regarding the MediaTek Little Kernel (LK v0.5) bootloader chain and binary header layout for the **TECNO IN6 / H633** (MediaTek MT6763 / Helio P23).

---

## 1. Verified Bootloader Evidence

| Dimension | Value / Parameter | Evidence Source | Technical Impact |
|---|---|---|---|
| **Bootloader Engine** | MediaTek LK v0.5 | `fastboot getvar all` (`kernel: lk`, `version: 0.5`) | Standard MediaTek 64-bit Little Kernel bootloader |
| **Product Target** | `IN6_H633` | `fastboot getvar product` | Exact hardware board platform target |
| **Bootloader Lock State** | `unlocked: yes` | `fastboot getvar unlocked` | Hardware signature verification disabled for boot partition |
| **Secure Boot State** | `secure: no` | `fastboot getvar secure` | Unsigned kernel execution permitted in RAM |
| **Partition Scheme** | Traditional Non-A/B | `/proc/partitions` & Android mount table | Single slot partition mapping (`/dev/block/mmcblk0p25`: boot) |
| **Boot Partition Size** | `0x2000000` (32 MB) | `fastboot getvar partition-size:boot` | Maximum candidate image size limit |
| **Fastboot Protocol** | `fastboot fetch` **NOT SUPPORTED** | LK fastboot response (`Device does not support fetch command`) | Stock boot.img cannot be pulled via fastboot |
| **ADB Shell State** | `uid=2000(shell)` Non-Root | ADB shell query (`adbd cannot run as root in production builds`) | Direct `/dev/block/` raw partition reading is denied |

---

## 2. Android Header Version 0 Layout Specifications

MediaTek LK v0.5 expects the candidate `boot.img` to conform to the standard Android Header v0 binary layout:

```
+-------------------------------------------------------+
|  Bytes 0 - 7: Magic "ANDROID!" (8 bytes)              |
+-------------------------------------------------------+
|  Bytes 8 - 39: Payload Sizes & Addresses (8 x 4B)     |
|    - kernel_size (0x08), kernel_addr (0x40008000)     |
|    - ramdisk_size (0x10), ramdisk_addr (0x44000000)   |
|    - second_size (0x18), second_addr (0x40f00000)     |
|    - tags_addr (0x40000100), page_size (2048)         |
+-------------------------------------------------------+
|  Bytes 40 - 47: header_version (0) & os_version (0)   |
+-------------------------------------------------------+
|  Bytes 48 - 63: Board Name (16 bytes)                 |
+-------------------------------------------------------+
|  Bytes 64 - 575: Primary Kernel Cmdline (512 bytes)   |
+-------------------------------------------------------+
|  Bytes 576 - 607: SHA / ID Array (32 bytes)             |
+-------------------------------------------------------+
|  Bytes 608 - 1631: Extra Cmdline (1024 bytes)           |
+-------------------------------------------------------+
|  Bytes 1632 - 2047: Zero Padding to Page Boundary       |
+-------------------------------------------------------+
```

---

## 3. DRAM Load Address Offsets
- **Base Address**: `0x40000000`
- **Kernel Load Address**: `0x40008000` (Base + `0x8000`)
- **Ramdisk Load Address**: `0x44000000` (Base + `0x04000000`)
- **Tags / ATAGS / FDT Address**: `0x40000100` (Base + `0x0100`)
- **Second Stage Address**: `0x40f00000`
