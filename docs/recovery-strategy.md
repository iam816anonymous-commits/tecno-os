# IN6-Linux Recovery Strategy & Safety Boundaries

## Overview
This document specifies the emergency recovery strategy and hardware safety boundaries for the **TECNO IN6 / H633**.

> **CRITICAL WARNING**:
> **NO VERIFIED STOCK FACTORY RECOVERY IMAGE CURRENTLY AVAILABLE.**
> Modifying critical calibration or boot partitions will cause **PERMANENT HARDWARE BRICKING**.
> Purchasing stock firmware is not a prerequisite for research, but permanent flashing without a factory image is strictly prohibited.

---

## 1. Partition Criticality & Safety Classification

| Partition | Block Device | Criticality | Safety Directive | Potential Consequence of Corruption |
|---|---|---|---|---|
| `preloader_a` / `b` | `/dev/block/mmcblk0boot0` | **EXTREME** | **NEVER TOUCH** | Complete, irreversible hardware brick. BROM boot loop. |
| `nvram` | `/dev/block/mmcblk0p7` | **EXTREME** | **NEVER TOUCH** | Permanent loss of IMEI, Wi-Fi MAC, and RF calibration data. |
| `nvdata` / `nvcfg` | `/dev/block/mmcblk0p16` | **EXTREME** | **NEVER TOUCH** | Cellular baseband failure, no network signal. |
| `protect1` / `protect2`| `/dev/block/mmcblk0p5` | **EXTREME** | **NEVER TOUCH** | Security cert loss, DRM/TEE boot failure. |
| `lk` / `lk2` | `/dev/block/mmcblk0p3` | **HIGH** | **DO NOT TOUCH** | Fastboot bootloader loss. USB recovery required via SP Flash Tool. |
| `boot` | `/dev/block/mmcblk0p25` | **MEDIUM** | Tethered Boot Only | System fails to boot to Android. Recoverable via `fastboot boot`. |
| `system` / `vendor` | `/dev/block/mmcblk0p31` | **MEDIUM** | Read-Only Mount | Android userspace failure. Recoverable if stock backup obtained. |
| `userdata` | `/dev/block/mmcblk0p33` | **LOW** | Target Linux RootFS | Loss of Android user data. |

---

## 2. Recovery Pathways & Safe Operations

### Recovery Pathway 1: Non-Destructive Tethered Boot (`fastboot boot`)
- **Mechanism**: The candidate kernel image is uploaded into RAM and executed directly by LK without altering any eMMC block device.
- **Recovery Action**: Simply rebooting or power-cycling the phone restores stock Android execution from internal flash memory.

### Recovery Pathway 2: Stock Android Restoration
- In the event that a tethered boot test fails or hangs:
  1. Hold **Power + Volume Down** to force power-down and enter Fastboot mode.
  2. Execute:
     ```bash
     fastboot reboot
     ```
  3. Device boots stock Android OS seamlessly.

---

## 3. Mandatory Rules for Experimental Flashing
1. **NO FLASHING WITHOUT FACTORY BACKUP**: Experimental flashing of `boot`, `system`, or `vendor` partitions is strictly prohibited until a full factory firmware package is acquired and validated.
2. **NO MODIFICATION OF PRELOADER OR NVRAM**: Under no circumstances will any script in this project write to `preloader` or `nvram` partitions.
