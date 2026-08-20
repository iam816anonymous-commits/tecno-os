# IN6-Linux Physical Bring-Up Level Definitions

## Overview
This document defines objective technical criteria for evaluating physical kernel bring-up milestones on the **TECNO IN6 / H633**.

A boot test is **NOT** classified as successful merely because the phone vibrates, displays a splash logo, or lights up the screen backlight. Objective evidence of Linux kernel execution is required for each level.

---

## Bring-Up Success Levels

### Level 1: Early Kernel Execution & Serial Output
- **Criterion**: The kernel parses ATAGS/FDT device tree and writes early boot messages to serial console / USB gadget.
- **Evidence**: `earlycon` log strings (`[ 0.000000] Booting Linux on physical CPU 0x0000000000 [0x410fd034]`).

### Level 2: Kernel Drivers & Initramfs Load
- **Criterion**: The kernel initializes memory management, GIC interrupt controller, and decompresses initramfs archive into RAM.
- **Evidence**: Kernel log displays `Unpacking initramfs...` and mounts `devtmpfs`.

### Level 3: Userspace `/init` Execution
- **Criterion**: The kernel transitions from kernel mode to user space and executes `/init` binary/script.
- **Evidence**: The diagnostic script runs and prints the IN6-Linux welcome banner to console/tty:
  ```
  ==================================================
           IN6-LINUX BRING-UP
           TECNO IN6 / H633 (MT6763)
  ==================================================
  ```

### Level 4: Diagnostic Shell & Communication Interface
- **Criterion**: Initramfs starts an interactive shell (`/bin/sh`) or USB CDC ACM gadget (`/dev/ttyGS0`).
- **Evidence**: Host system detects USB serial interface and responds to shell commands (`uname -a`, `cat /proc/cpuinfo`).

### Level 5: Framebuffer / Display & Touch Input
- **Criterion**: DRM/KMS display driver renders graphics buffer to screen and touchscreen event device (`/dev/input/event2`) processes touch events.
- **Evidence**: Direct rendering to `/dev/dri/card0` and touch event logs in `evtest`.

### Level 6: Core Peripherals & Base Subsystem Integration
- **Criterion**: Operational drivers for internal eMMC storage (`mmc0`), Wi-Fi (`wlan_drv_gen2`), Bluetooth (`btmtkuart`), ALSA Audio (`MT6358 AFE`), and power management.
- **Evidence**: Active network interface (`wlan0`), mounted ext4/f2fs partitions, and sound card playback.
