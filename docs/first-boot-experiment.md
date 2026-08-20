# IN6-Linux First Boot Experiment Protocol

## Overview
This document specifies the exact physical experiment protocol for testing the **IN6-Linux** candidate kernel image (`build/artifacts/boot.img`) on the **TECNO IN6 / H633**.

> **STRICT SAFETY POLICY**:
> This protocol uses **ONLY** non-destructive, tethered boot operations (`fastboot boot`).
> Flashing (`fastboot flash`), partition erasing, or block writing is **STRICTLY PROHIBITED**.

---

## 1. Preconditions & Requirements

- **Device State**: TECNO IN6 with unlocked bootloader (`unlocked: yes`, `secure: no`).
- **Battery**: Minimum 70% charge to prevent mid-boot power loss.
- **USB Cable**: Verified USB-A to Micro-USB cable connected directly to host PC.
- **Host Dependencies**: `fastboot` and `adb` utilities installed on host machine.
- **Candidate Image**: `build/artifacts/boot.img` generated and validated by `tools/boot/validate_boot_image.py`.

---

## 2. Experimental Test Sequence

### Step 1: Bootloader Handoff Verification
1. Reboot phone into Fastboot Mode (Hold Volume Down + Power button on startup).
2. Query bootloader device state:
   ```bash
   fastboot getvar all
   ```
3. Confirm `unlocked: yes` and `product: IN6_H633`.

### Step 2: Non-Destructive Tethered Boot
1. Execute tethered boot command from host PC:
   ```bash
   fastboot boot build/artifacts/boot.img
   ```
2. Observe LK bootloader response:
   - **PASS**: LK accepts header, downloads payload to RAM (`0x40008000`), and jumps to kernel entry point.
   - **FAIL**: Bootloader rejects header or immediately reboots.

### Step 3: Kernel Execution & Serial Handoff
1. Monitor USB Serial Gadget on host machine (`/dev/ttyGS0` on Linux or COM port on Windows).
2. Check for early console output from kernel `earlycon` (`0x11002000`).

---

## 3. Success vs Failure Criteria

### What Success Looks Like
- Kernel successfully parses device tree (`mt6763-tecno-in6.dtb`).
- Kernel mounts `devtmpfs` and executes `/init` from initramfs.
- Init script prints the IN6-Linux welcome banner to serial console/screen:
  ```
  ==================================================
           IN6-LINUX BRING-UP
           TECNO IN6 / H633 (MT6763)
  ==================================================
  ```
- Shell interface (`/bin/sh`) becomes active and responsive.

### What Failure Looks Like
1. **Immediate Reboot**: Bootloader header mismatch or kernel memory panic.
2. **Stuck at TECNO Logo**: Kernel execution started but display driver or serial output failed.
3. **Watchdog Reset**: Kernel hung before feeding watchdog timer.

---

## 4. Non-Destructive Log Collection Method
If failure occurs, reboot device back into Fastboot mode using hardware key combination. Query last kmsg if supported by LK:
```bash
fastboot oem log
```
Never attempt to fix a boot panic by flashing internal device partitions.
