# MediaTek MT6763 Kernel Source Lineage & Candidates

## Overview
This document evaluates candidate Linux kernel sources for the **TECNO IN6 / H633** (MediaTek MT6763 / Helio P23, Android 8.1.0, Linux 4.4.95+, `CONFIG_CUSTOM_TRAN_PROJECT="tran_in6"`).

To achieve successful initial boot bring-up, candidate kernel trees are prioritized by vendor lineage and hardware proximity.

---

## Candidate Kernel Sources Matrix

### Candidate 1: Transsion / Tecno MT6763 Android 4.4 Kernel (`Power535/android_kernel_common_MT6763`)
- **Repository URL**: `https://github.com/Power535/android_kernel_common_MT6763`
- **Branch**: `4.4` / `android-8.1`
- **Kernel Version**: Linux 4.4.95
- **Device / SoC**: MediaTek MT6763 (Transsion / Infinix / Tecno reference)
- **Vendor**: Transsion / MediaTek
- **Relevance**: **CRITICAL (PRIMARY BRING-UP REFERENCE)**
- **Kernel Drivers**: Includes complete MediaTek MT6763 vendor drivers (`wmt_drv`, `ccci`, `mtk-tpd`, `mt6358` PMIC).
- **Device Tree**: Contains MT6763 common DTSI (`mt6763.dtsi`) and MediaTek board config templates.
- **Transsion Project Flags**: Directly supports `tran_in6` / `tran_in6_a1` configuration structure.
- **Usability**: **HIGH**. Best source for initial LK bootloader compatibility and register-accurate peripheral initialization.
- **License**: GPL-2.0

### Candidate 2: UMIDIGI Breeze / A5 Pro MT6763 Kernel (`umidigi-mt6763-dev/android_device_umidigi_breeze-kernel`)
- **Repository URL**: `https://github.com/umidigi-mt6763-dev/android_device_umidigi_breeze-kernel`
- **Branch**: `lineage-17.1` / `4.4`
- **Kernel Version**: Linux 4.4.146
- **Device / SoC**: UMIDIGI Breeze / A5 Pro (MediaTek MT6763 / Helio P23)
- **Vendor**: UMIDIGI / MediaTek
- **Relevance**: **HIGH (COMPARATIVE HARDWARE REFERENCE)**
- **Kernel Drivers**: MediaTek MT6763 Android 4.4 display, pinctrl, audio, and PMIC drivers.
- **Differences**: Uses UMIDIGI board pinmux and different panel/touch ICs.
- **Usability**: **MEDIUM**. Useful for comparing MT6763 pinmux and 4.4 kernel patches.
- **License**: GPL-2.0

### Candidate 3: MT6763 Mainline Linux Kernel (`mtk-mainline/mt6763/linux`)
- **Repository URL**: `https://gitlab.com/mtk-mainline/mt6763/linux`
- **Branch**: `mt6763-v6.1`
- **Kernel Version**: Linux 6.1 LTS
- **Device / SoC**: Volla Phone 2020 (`mt6763v-volla-yggdrasil`) / Generic MT6763
- **Vendor**: Community Mainline / Volla
- **Relevance**: **LONG-TERM TARGET**
- **Kernel Drivers**: Modern DRM/KMS, Panfrost GPU driver, upstream `mtk-sd` eMMC driver.
- **Differences**: Lacks legacy MediaTek out-of-tree drivers (`wmt_drv.ko`, `ccci`). Uses device-tree bindings for Linux 6.1.
- **Usability**: **MEDIUM (PHASE 2 TARGET)**. Requires complete board DTS definition before early console/boot can be verified.
- **License**: GPL-2.0

---

## Lineage Evaluation & Recommendation
1. **Initial Boot Phase**: Utilize **Candidate 1 (Transsion MT6763 4.4 Kernel)** as the reference source for initial LK header and boot image validation.
2. **Mainline Migration Phase**: Port verified IN6 board parameters from Phase 1 to **Candidate 3 (MT6763 Mainline 6.1)** once bootloader execution and serial/USB console handoff are confirmed.
