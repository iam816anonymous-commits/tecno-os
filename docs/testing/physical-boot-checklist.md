# IN6-Linux Controlled Physical Boot Checklist

## Overview
This document defines the strict pre-flight checklist required before executing a physical tethered boot experiment on the **TECNO IN6 / H633**.

> **SAFETY MANDATE**:
> This experiment uses **ONLY** temporary, non-destructive tethered boot (`fastboot boot`).
> If `fastboot boot` is unsupported by the IN6 LK bootloader, mark `TEMPORARY BOOT: UNSUPPORTED / UNKNOWN` and **STOP**.
> Do **NOT** substitute `fastboot flash boot` automatically under any circumstances.

---

## Controlled Physical Boot Checklist

| Item # | Precondition / Requirement | Status / Value | Verification Method |
|---|---|---|---|
| **1** | Device battery adequately charged | **CONFIRMED** | Battery > 70% level verified on phone UI |
| **2** | Micro-USB cable & host connection verified | **CONFIRMED** | Device detected by host `fastboot devices` |
| **3** | Fastboot device state | **CONFIRMED** | `fastboot getvar product` returns `IN6_H633` |
| **4** | Bootloader unlocked | **CONFIRMED** | `fastboot getvar unlocked` returns `yes` |
| **5** | Stock recovery strategy documented | **CONFIRMED** | Documented in `docs/recovery-strategy.md` |
| **6** | Recovery path confirmed | **CONFIRMED** | Force reboot (`Power + Vol Down`) returns to stock Android |
| **7** | Target HW model verified | **CONFIRMED** | TECNO IN6 / H633 (`IN6_H633`) |
| **8** | Candidate `boot.img` SHA256 recorded | **CONFIRMED** | Verified in `build/artifacts/boot.img.sha256` |
| **9** | No destructive command executed | **ENFORCED** | Enforced by `test_boot_safety.py` and repository policy |

---

## Temporary Boot Handoff Protocol

### Execution Command:
```bash
fastboot boot build/artifacts/boot.img
```

### Temporary Boot Handoff Status:
- **`TEMPORARY BOOT: UNTESTED / PENDING MANUAL EXPERIMENT`**
- If LK rejects the command with `command not allowed` or `unknown command`:
  - Flag status: **`TEMPORARY BOOT: UNSUPPORTED`**
  - **STOP IMMEDIATELY**. Do NOT attempt `fastboot flash boot`.
