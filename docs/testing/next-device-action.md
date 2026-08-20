# IN6-Linux Next Physical Device Action & Hardware Blocker Resolution

## Overview
This document specifies the exact physical device procedure that the user must execute to perform the first non-destructive real-hardware boot experiment on the **TECNO IN6 / H633** (MediaTek MT6763).

---

## Current Hardware Bring-Up Blocker

| Blocker Dimension | Technical Description | Resolution Strategy |
|---|---|---|
| **Primary Blocker** | Physical execution telemetry has not yet been performed on the TECNO IN6. | Execute tethered `fastboot boot` payload in RAM. |
| **Recovery Blocker** | No stock factory firmware package or stock `boot.img` dump exists in repository. | **STRICT NON-DESTRUCTIVE TETHERED BOOT ONLY**. Flashing (`fastboot flash`) is permanently prohibited. |
| **Shell Root Blocker** | ADB shell is `uid=2000(shell)` without root access; direct block device reading is denied (`Permission denied`). | Use Fastboot mode tethered RAM boot. |

---

## Exact User Device Procedure (Tethered Boot Experiment)

### Step 1: Device Preparation & Verification
1. Ensure the TECNO IN6 battery is charged to at least **70%**.
2. Connect the phone to the host development PC using a known-good Micro-USB cable.
3. Power off the TECNO IN6 completely.
4. Press and hold **Volume Down + Power Button** simultaneously to enter Fastboot Mode.
5. On the host development PC, verify Fastboot connectivity:
   ```bash
   fastboot devices
   fastboot getvar product
   ```
   - **Expected Output**: Returns device serial number and `product: IN6_H633`.

### Step 2: Execute Non-Destructive Tethered Boot Command
On the host development PC, execute the candidate boot image payload directly into device RAM:
```bash
fastboot boot build/artifacts/boot.img
```

### Step 3: Observable Evidence & Diagnostic Verification
1. **LK Bootloader Response**:
   - **PASS**: Fastboot prints `downloading 'boot.img'... OKAY`, `booting... OKAY`.
   - **FAIL / UNSUPPORTED**: Bootloader returns `unknown command` or `command not allowed`.
2. **USB Serial Gadget / Kernel Handoff**:
   - Monitor host serial ports (`/dev/ttyACM0` / `/dev/ttyGS0` on Linux, or COM port on Windows).
   - If kernel executes, the initramfs script will write the welcome banner:
     ```
     ==================================================
              IN6-LINUX BRING-UP
              TECNO IN6 / H633 (MT6763)
     ==================================================
     ```

---

## What Success vs Failure Looks Like

### Success Criteria:
- **Level 1**: Kernel outputs early boot messages via `earlycon=uart8250,mmio32,0x11002000`.
- **Level 2**: Kernel mounts initramfs and executes `/init`.
- **Level 3**: USB CDC ACM serial gadget exposes a diagnostic `/bin/sh` shell to host PC.

### Failure Outcomes & Recovery:
- **Outcome A (Fastboot Boot Unsupported)**: LK rejects command.
  - **Action**: Mark `TEMPORARY BOOT: UNSUPPORTED`. **STOP**. Do NOT substitute `fastboot flash boot`.
- **Outcome B (Kernel Panic / Hang)**: Screen remains black or stuck on logo.
  - **Action**: Hold **Power + Volume Down** for 10 seconds to force reboot. Device reboots safely to stock Android.
