# IN6-Linux First Device Boot Protocol & Experiment Procedure

## Overview
This document specifies the exact physical experiment protocol for executing the candidate boot image payload (`build/artifacts/boot.img`) on the **TECNO IN6 / H633**.

> **STRICT SAFETY POLICY**:
> This experiment uses **ONLY** non-destructive, temporary tethered boot (`fastboot boot`).
> Flashing (`fastboot flash`), partition erasing, or block writing is **STRICTLY PROHIBITED**.

---

## 1. Physical Device Pre-Flight Checklist

| Checklist Item | Requirement | Verification Method |
|---|---|---|
| **1. Battery Level** | > 70% Charge | Verified on phone lockscreen / battery icon |
| **2. USB Connection** | Known-good Micro-USB cable connected to host PC | `fastboot devices` returns device serial |
| **3. Bootloader State** | Unlocked LK v0.5 | `fastboot getvar unlocked` returns `yes` |
| **4. Device Identity** | TECNO IN6 / H633 | `fastboot getvar product` returns `IN6_H633` |
| **5. Image Validation** | `build/artifacts/boot.img` valid | `python3 tools/boot/validate_boot_image.py build/artifacts/boot.img` PASS |
| **6. Checksum Audit** | SHA256 matches build hash | `sha256sum -c build/artifacts/boot.img.sha256` PASS |

---

## 2. Exact Execution Command
On the host development PC, execute:
```bash
fastboot boot build/artifacts/boot.img
```

---

## 3. Observable Evidence & Diagnostic Outcomes

### Outcome 1: Level 1 / Level 2 Success (Kernel & Initramfs Execution)
- **LK Handoff**: `fastboot boot` outputs `downloading 'boot.img'... OKAY`, `booting... OKAY`.
- **Early Console**: Kernel writes early boot strings to UART0 (`0x11002000`).
- **Initramfs Welcome Banner**: USB CDC ACM gadget (`/dev/ttyGS0`) enumerates on host PC and outputs:
  ```
  ==================================================
           IN6-LINUX BRING-UP
           TECNO IN6 / H633 (MT6763)
  ==================================================
  ```

### Outcome 2: Temporary Boot Unsupported by LK
- **LK Handoff**: Fastboot returns `unknown command` or `command not allowed`.
- **Action**: Mark `TEMPORARY BOOT: UNSUPPORTED`. **STOP IMMEDIATELY**. Do NOT attempt `fastboot flash boot`.

### Outcome 3: Kernel Panic / Hang
- **Device State**: Screen remains black or frozen at logo.
- **Recovery Procedure**: Hold **Power + Volume Down** for 10 seconds to force power-down and reboot cleanly to stock Android.
