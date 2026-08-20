# Proprietary Firmware Requirements & Licensing Audit

## Overview
Certain hardware peripherals on the TECNO IN6 rely on microcode/firmware binaries loaded into chip memory at boot time. This document audits required firmware and licensing rules.

---

## Firmware Hierarchy & Classification

| Peripheral | Hardware Chip | Required Firmware Binary | Source Location | Redistribution Status | License |
|---|---|---|---|---|---|
| **Wi-Fi** | MT6631 / MT6625L | `WLAN_RAM_CODE_MT6763` | `/vendor/firmware/` | Restricted Vendor Binary | MediaTek Proprietary |
| **Bluetooth** | MT6631 / MT6625L | `stpbt.bin` | `/vendor/firmware/` | Restricted Vendor Binary | MediaTek Proprietary |
| **GPS** | MT6631 / MT6625L | `GPS_CORE_INT2_MT6763.bin` | `/vendor/firmware/` | Restricted Vendor Binary | MediaTek Proprietary |
| **Modem DSP** | MT6763 Baseband | `md1img.img`, `md1dsp.img` | Stock Partition (`md1img`) | Restricted Vendor Binary | MediaTek Proprietary |
| **GPU** | Mali-G71 MP2 | Panfrost Open Driver | Upstream Linux | Open Source | Open Source / GPL |

---

## Licensing & Repository Rules
1. **NO PROPRIETARY BLOBS IN GIT**: Never commit proprietary `.bin`, `.img`, or `.elf` vendor blobs directly to the IN6-Linux repository.
2. **Local Extraction Tooling**: Provide extraction scripts (`tools/firmware/extract-firmware.sh`) that pull necessary firmware files locally from user-provided stock vendor dumps.
