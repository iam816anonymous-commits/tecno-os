# IN6-Linux Execution Observability Protocol

## Overview
This document specifies the early boot observability channels and detection vectors for verifying kernel execution on the **TECNO IN6 / H633**.

---

## Observability Channels & Detection Matrix

| Channel # | Observability Vector | Technical Mechanism | Detection Method | Status / Evidence Basis |
|---|---|---|---|---|
| **Channel 1** | UART0 Early Console | MMIO 32-bit writes to `0x11002000` | Physical serial cable attached to motherboard test pads | `UNKNOWN — REQUIRES IN6 MEASUREMENT` |
| **Channel 2** | USB CDC ACM Serial Gadget | Kernel `mtu3` USB gadget driver (`/dev/ttyGS0`) | Host PC detects `/dev/ttyACM0` and reads `dmesg` stream | **[PROTOTYPE]** |
| **Channel 3** | Initramfs Diagnostic Banner | Executable `/init` script in gzip cpio archive | Welcome banner string written to TTY / USB gadget | **[HOST-VALIDATED]** |
| **Channel 4** | DRM Framebuffer Display | MediaTek DRM driver rendering to `/dev/dri/card0` | Display renders graphical splash pattern | `REQUIRES_IN6_MEASUREMENT` |

---

## Log Capture & Evidence Storage
Captured serial / USB gadget logs must be saved to `inventory/physical-boot-logs/` with timestamped filenames (`in6-boot-log-YYYYMMDD.txt`) and evaluated by `tools/testing/collect_device_evidence.py`.
