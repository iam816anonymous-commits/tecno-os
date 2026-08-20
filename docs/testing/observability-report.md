# IN6-Linux Physical Execution Observability Specification

## Overview
This document specifies the exact detection vectors used to prove that the candidate Linux kernel has executed on the physical **TECNO IN6 / H633**.

---

## Observability Detection Vectors

```
+-------------------------------------------------------------+
|    Vector 1: UART0 Serial Console (`earlycon` at 0x11002000) |
+-------------------------------------------------------------+
                               |
                               v
+-------------------------------------------------------------+
|    Vector 2: USB CDC ACM Serial Gadget (`/dev/ttyGS0`)      |
+-------------------------------------------------------------+
                               |
                               v
+-------------------------------------------------------------+
|    Vector 3: Initramfs Welcome Banner & Shell Output        |
+-------------------------------------------------------------+
                               |
                               v
+-------------------------------------------------------------+
|    Vector 4: Framebuffer / DRM Display Splash               |
+-------------------------------------------------------------+
```

---

## Detection Vector Breakdown

### 1. UART0 Serial Console (`0x11002000`)
- **Kernel Argument**: `earlycon=uart8250,mmio32,0x11002000 console=ttyS0,115200n8`
- **Mechanism**: Direct 32-bit MMIO register writes to MediaTek UART0 core at `0x11002000`.
- **Physical Test Pads**: `UNKNOWN — REQUIRES IN6 MEASUREMENT`. Test pads on motherboard require scope/multimeter probing.

### 2. USB CDC ACM Serial Gadget (`/dev/ttyGS0`)
- **Mechanism**: Kernel USB gadget driver enumerates a virtual serial port over the Micro-USB port upon boot.
- **Verification**: Host PC detects `/dev/ttyACM0` (Linux) or COM port (Windows) and receives `dmesg` streaming log.

### 3. Initramfs Shell Execution
- **Mechanism**: Initramfs mounts `/proc`, `/sys`, `/dev` and executes `/init` diagnostic script.
- **Evidence String**:
  ```
  ==================================================
           IN6-LINUX BRING-UP
           TECNO IN6 / H633 (MT6763)
  ==================================================
  ```

### 4. DRM Framebuffer Display
- **Mechanism**: MediaTek DRM driver renders graphical console to `/dev/dri/card0`.
- **Status**: `REQUIRES_IN6_MEASUREMENT` (Panel init sequence pending extraction).
