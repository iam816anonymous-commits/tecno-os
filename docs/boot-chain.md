# TECNO IN6 Boot-Chain Analysis & Security Model

## Overview
This document analyzes the MediaTek boot sequence on the **TECNO IN6 / H633** and defines the initial execution target for **IN6-Linux**.

---

## Boot Sequence Flowchart

```
+-------------------------------------------------------+
|                    Power-On / Reset                   |
+-------------------------------------------------------+
                           |
                           v
+-------------------------------------------------------+
|               Boot ROM (BROM) [Mask ROM]              |
|        (Vendor immutable; verifies Preloader signature)|
+-------------------------------------------------------+
                           |
                           v
+-------------------------------------------------------+
|             Preloader (`/dev/block/mmcblk0boot0`)     |
|   (Initializes DRAM / LPDDR, basic hardware & LK load) |
+-------------------------------------------------------+
                           |
                           v
+-------------------------------------------------------+
|             Little Kernel (LK / `lk` partition)       |
|    (Bootloader; verifies boot image & passes cmdline)  |
+-------------------------------------------------------+
                           |
                           v
+-------------------------------------------------------+
|               Boot Image (`boot` partition)           |
|        (Android Header v0: Kernel + DTB + Ramdisk)    |
+-------------------------------------------------------+
                           |
                           v
+-------------------------------------------------------+
|                  Linux Kernel (6.1 LTS)               |
|      (Mounts rootfs, executes `/init` userspace)      |
+-------------------------------------------------------+
                           |
                           v
+-------------------------------------------------------+
|                  IN6-Linux Userspace                  |
|          (Init -> Device Manager -> Shell)            |
+-------------------------------------------------------+
```

---

## Boot Components Categorization

| Boot Component | Control / Source | Replaceable? | Risk Level | Project Policy |
|---|---|---|---|---|
| **Boot ROM (BROM)** | MediaTek Silicon | No (ROM) | N/A | Immutable Silicon Code. |
| **Preloader** | MediaTek Proprietary | No | **CRITICAL** | **DO NOT TOUCH**. Modifying preloader bricks device. |
| **LK / LK2** | MediaTek / LK Source | Optional | **HIGH** | Keep stock LK; bootloader is already unlocked. |
| **NVRAM / NVDATA** | Proprietary Calibrations| No | **CRITICAL** | **DO NOT TOUCH**. Contains IMEI/MAC/RF calibration. |
| **Boot Image** | Open Source (IN6-Linux) | **YES** | **LOW** | Primary target (`boot.img` kernel + initramfs). |
| **System / Vendor** | Open Source (IN6-Linux) | **YES** | **LOW** | Target rootfs partition (`/dev/mmcblk0p31`). |

---

## Unlocked Bootloader Capabilities & Boundaries
- **Capabilities**: Permits booting unsigned kernel images (`fastboot boot boot.img`) and flashing custom `boot` / `system` / `vendor` / `userdata` partitions.
- **Boundaries**: Does NOT bypass hardware execution checks in BROM or Preloader. Does NOT protect NVRAM from overwrite if targeted accidentally.
