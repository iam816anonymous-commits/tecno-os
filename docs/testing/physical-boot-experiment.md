# IN6-Linux Physical Tethered Boot Experiment Protocol

## Overview
This document specifies the pre-flight checklist, execution command, and 10-stage failure classification framework for conducting physical tethered boot tests on the **TECNO IN6 / H633** (MediaTek MT6763).

> **STRICT SAFETY DIRECTIVE**:
> All physical hardware bring-up tests MUST use temporary tethered boot (`fastboot boot`).
> Flashing (`fastboot flash`), partition erasing, or raw block writing is strictly prohibited.

---

## 1. Pre-Flight Checklist

| Checklist Item | Requirement | Verification Method |
|---|---|---|
| **1. Battery Charge** | > 70% Charge | Verified on stock phone UI / battery icon |
| **2. USB Connection** | Direct Micro-USB cable connection to host PC | `fastboot devices` returns device serial |
| **3. Bootloader State** | Unlocked LK v0.5 | `fastboot getvar unlocked` returns `yes` |
| **4. Hardware Model** | TECNO IN6 / H633 | `fastboot getvar product` returns `IN6_H633` |
| **5. Image Validation** | `build/artifacts/boot.img` structurally valid | `python3 tools/boot/validate_boot_image.py build/artifacts/boot.img` PASS |
| **6. Payload Hash** | SHA256 matches build hash | `sha256sum -c build/artifacts/boot.img.sha256` PASS |

---

## 2. Non-Destructive Tethered Boot Command
Execute on host development PC:
```bash
fastboot boot build/artifacts/boot.img
```

---

## 3. Ten-Stage Physical Boot Failure Classification Framework

When executing `fastboot boot build/artifacts/boot.img`, classify the exact point of failure using this 10-stage diagnosis tree:

| Failure Stage # | Diagnostic Stage | Failure Symptom / Evidence | Root Cause & Next Resolution Action |
|---|---|---|---|
| **Stage 0** | Bootloader Image Rejection | Fastboot outputs `unknown command` or `command not allowed` | Temporary boot unsupported by LK v0.5. **STOP IMMEDIATELY**. |
| **Stage 1** | Image Download Handoff | Fastboot hangs during `downloading 'boot.img'` | USB PHY communication error or payload size exceeds RAM limit. |
| **Stage 2** | Boot Header Parsing | LK reports header magic mismatch or invalid page size | Android Header v0 struct offset mismatch. Re-verify `build/build-image.sh`. |
| **Stage 3** | Decompressor Failure | Phone screen freezes at LK splash logo; no serial output | Gzip kernel decompression failure. Check `Image.gz` gzip header alignment. |
| **Stage 4** | DTB Parsing / ATAGS | Kernel panics during `setup_arch()` before console | Device tree node incompatibility or memory base address mismatch. |
| **Stage 5** | Early Kernel Panic | Screen stays black; `earlycon` outputs register fault | Drivers or clocks missing in `in6-stock-defconfig`. Check UART0 base (`0x11002000`). |
| **Stage 6** | Platform / GIC Driver Crash| Kernel panics during IRQ / timer / PMIC initialization | GIC-v3 or MT6358 PMIC wrapper driver fault in kernel. |
| **Stage 7** | Initramfs Execution Failure| Kernel panics with `Kernel panic - not syncing: Attempted to kill init!`| `/init` binary missing, invalid shebang syntax, or missing `/dev/console`. |
| **Stage 8** | USB Gadget / Serial Failure| Kernel boots `/init` but no USB CDC ACM gadget enumerates | `mtu3` USB PHY driver or CDC ACM gadget config missing in defconfig. |
| **Stage 9** | Userspace Shell Crash | `/init` executes banner then shell crashes | Missing C library dependencies or missing tty device nodes in initramfs. |

---

## 4. Safe Force-Reboot Recovery
If the device hangs at any stage:
1. Press and hold **Power Button + Volume Down** simultaneously for 10 seconds.
2. The TECNO IN6 powers down completely and reboots safely into the un-modified stock Android OS on internal eMMC flash.
