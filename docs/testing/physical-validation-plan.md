# IN6-Linux Physical Hardware Validation Protocol

## Overview
This document specifies the exact physical experiment protocol for validating the candidate boot image payload (`build/artifacts/boot.img`) on the **TECNO IN6 / H633**.

> **NON-DESTRUCTIVE SAFETY DIRECTIVE**:
> All physical experiments MUST use temporary tethered boot (`fastboot boot`).
> Flashing (`fastboot flash`), partition erasing, or raw block writing is strictly prohibited.

---

## Pre-Flight Checklist

1. **Battery Level**: Verify charge level > 70%.
2. **USB Connection**: Connect phone via Micro-USB to host development PC.
3. **Fastboot Mode**: Power off phone; hold **Volume Down + Power** to enter Fastboot Mode.
4. **Device State**: Run `fastboot getvar product` (must return `IN6_H633`) and `fastboot getvar unlocked` (must return `yes`).
5. **Artifact Verification**: Confirm `build/artifacts/boot.img` exists and passes `tools/boot/validate_boot_image.py`.

---

## Physical Tethered Boot Command
Execute on host development PC:
```bash
fastboot boot build/artifacts/boot.img
```

---

## Expected Outcomes & Log Capture

### Outcome A: Success (Level 1 / Level 2 Bring-Up)
- **LK Bootloader**: Downloads payload to RAM (`0x40008000`) and jumps to kernel entry point.
- **Kernel Execution**: Kernel prints `earlycon` messages to UART0 (`0x11002000`).
- **Initramfs Shell**: USB CDC ACM gadget enumerates (`/dev/ttyGS0` or `/dev/ttyACM0`) and writes welcome banner:
  ```
  ==================================================
           IN6-LINUX BRING-UP
           TECNO IN6 / H633 (MT6763)
  ==================================================
  ```

### Outcome B: Command Unsupported
- **LK Bootloader**: Returns `unknown command` or `command not allowed`.
- **Action**: Mark `TEMPORARY BOOT: UNSUPPORTED`. **STOP IMMEDIATELY**. Do NOT execute `fastboot flash boot`.

### Outcome C: Boot Hang / Panic
- **Device State**: Screen remains black or frozen at logo.
- **Recovery**: Hold **Power + Volume Down** for 10 seconds to force reboot. System returns safely to stock Android.
