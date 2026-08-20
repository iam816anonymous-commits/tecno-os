# IN6-Linux QEMU Software Boot Evaluation Report

## Overview
This document evaluates the feasibility and results of running the **IN6-Linux** candidate kernel (`build/artifacts/Image.gz`) and device tree (`build/artifacts/mt6763-tecno-in6.dtb`) under QEMU software emulation (`qemu-system-aarch64`).

---

## Technical Evaluation & Result

> **EVALUATION RESULT**: **QEMU NOT APPLICABLE**

### Technical Justification
1. **MediaTek MT6763 Proprietary IP Cores**:
   The candidate kernel (`in6-stock-defconfig`) and device tree (`mt6763-tecno-in6.dts`) rely directly on MediaTek MT6763 hardware peripherals, including:
   - MediaTek Topckgen & Infracfg clock trees (`10000000`)
   - MediaTek Power Wrapper (`pwrap` at `1000d000`)
   - MediaTek MT6358 PMIC regulator interface
   - MediaTek 8250-compatible UART0 controller (`11002000`)
   - MediaTek GIC-v3 interrupt controller mappings
2. **Lack of QEMU Machine Model**:
   Generic QEMU ARM64 target (`qemu-system-aarch64 -M virt`) emulates standard ARM `virt` platform hardware (PL011 UART, Goldfish RTC, virtio block devices). QEMU does **NOT** contain a machine model for MediaTek MT6763 / Helio P23.
3. **Strict Non-Modification Directive**:
   Modifying the candidate kernel configuration or device tree (e.g. disabling MT6763 clock drivers or substituting `virtio` drivers) merely to force a generic QEMU `-M virt` emulation test to pass would corrupt the hardware accuracy of the IN6 target kernel.

---

## Conclusion
Boot testing on QEMU is **NOT APPLICABLE** for this SoC-specific candidate kernel. Validation must proceed via controlled physical boot analysis (`fastboot boot`).
