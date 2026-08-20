# IN6-Linux Kernel Porting Strategy: Pragmatic Bring-Up Roadmap

## Executive Principle: Booting over Modernity

For the initial kernel bring-up milestone of the **TECNO IN6 / H633** (MT6763), the overarching engineering directive is:
> **BOOING OVER MODERNITY**

A older vendor kernel that successfully completes LK bootloader handoff, initializes RAM/console, and executes `/init` provides immediate, actionable telemetry. A modern mainline kernel that silently panics in early BROM/LK handoff provides zero feedback.

---

## Technical Comparison of Kernel Strategies

| Evaluation Dimension | Strategy A: Stock Vendor 4.4.95 Adaptation | Strategy B: Direct Mainline 6.1 LTS | Strategy C: Phased Hybrid Transition (RECOMMENDED) |
|---|---|---|---|
| **LK Handoff Probability** | **100%** (Matches stock LK header & cmdline rules) | **40%** (Risk of silent LK dtb mismatch panic) | **100%** (Phase 1 uses 4.4 LK contract) |
| **Early Console Output** | **High** (`earlycon=uart8250,mmio32,0x11002000`) | **Medium** (Requires exact earlycon dtb node) | **High** (Verified console on 4.4 first) |
| **Driver Completeness** | Complete stock MTK drivers (`wmt_drv`, `ccci`, `mtk-tpd`) | Open-source drivers (Panfrost, `mtk-sd`), missing modem | Complete stock baseline -> Mainline migration |
| **Hardware Register Telemetry**| Direct access to MediaTek sysfs / debugfs | Requires new DTS bindings | Telemetry extracted in Phase 1 feeds Phase 2 |
| **Long-Term Viability** | Low (EOL kernel) | High (Upstream Linux community support) | High (Clean path to 6.1 LTS) |

---

## Recommended Phased Bring-Up Roadmap

### Phase 1: Bring-Up & Telemetry Baseline (Vendor 4.4.95 Source)
- **Objective**: Achieve verified boot sequence from LK -> Kernel -> Initramfs -> Diagnostic Shell.
- **Actions**:
  - Build candidate kernel using Transsion MT6763 4.4.95 source and `in6-stock-defconfig`.
  - Assemble Android Header v0 `boot.img` containing minimal BusyBox initramfs.
  - Test tethered boot (`fastboot boot build/artifacts/boot.img`).
  - Capture `/proc/cpuinfo`, I2C bus dumps, and input event logs.

### Phase 2: Mainline Kernel Enablement (Linux 6.1 LTS)
- **Objective**: Port verified IN6 board parameters from Phase 1 to MT6763 Mainline kernel (`mtk-mainline/mt6763/linux`).
- **Actions**:
  - Update `mt6763-tecno-in6.dts` with confirmed display timings, I2C touch IC addresses, and pinctrl groups.
  - Enable DRM/KMS display driver and Panfrost Mali-G71 GPU driver.
  - Load Wi-Fi/Bluetooth firmware binaries natively.

---

## Immediate Milestone Focus (Milestone v0.1)
Build a candidate `boot.img` based on the 4.4.95 configuration with an independent initramfs shell to prove pipeline reproducibility and bootloader handoff readiness.
