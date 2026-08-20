# Phase 3 Real Hardware Bring-Up Execution Strategy

## Executive Summary
This document specifies the execution strategy for **Phase 3: Real Hardware Bring-Up** of the **IN6-Linux** project targeting the **TECNO IN6 / H633** (MediaTek MT6763 / Helio P23).

---

## Phase 3 Execution Principles

1. **Non-Destructive Tethered Boot Strategy**:
   All physical hardware tests use **ONLY** temporary `fastboot boot` execution in RAM. Writing to internal flash partitions (`fastboot flash`) is strictly prohibited until a verified factory recovery image is acquired.
2. **Evidence-Based Hardware Enablement**:
   Peripherals are enabled in `kernel/configs/in6-stock-defconfig` and `device/tecno/in6/dts/mt6763-tecno-in6.dts` only when direct device telemetry or verified MT6763 platform specifications exist.
3. **Phased Kernel Progression**:
   - **Phase 3.1 Baseline**: Transsion MT6763 4.4.95 kernel tree for guaranteed Little Kernel (LK v0.5) bootloader handoff.
   - **Phase 3.2 Mainline Transition**: Migration to Linux 6.1 LTS once hardware telemetry (I2C touch IC, MIPI DSI panel timings) is captured from physical execution logs.

---

## Phase 3 Bring-Up Workflow

```
+-------------------------------------------------------------+
|    1. Verify Fastboot Device State (`fastboot getvar all`)  |
+-------------------------------------------------------------+
                               |
                               v
+-------------------------------------------------------------+
|    2. Build Candidate Boot Image (`build/build-image.sh`)   |
+-------------------------------------------------------------+
                               |
                               v
+-------------------------------------------------------------+
|    3. Tethered Boot Test (`fastboot boot boot.img`)         |
+-------------------------------------------------------------+
                               |
                               v
+-------------------------------------------------------------+
|    4. Monitor Serial / USB Gadget Log (`/dev/ttyGS0`)       |
+-------------------------------------------------------------+
                               |
                               v
+-------------------------------------------------------------+
|    5. Execute `/init` Diagnostic Shell & Collect Telemetry  |
+-------------------------------------------------------------+
```
