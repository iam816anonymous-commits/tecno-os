# IN6-Linux Research & Feasibility Report

## Executive Summary
This report presents the research findings and feasibility analysis for porting an independent, native Linux operating system (**IN6-Linux**) to the **TECNO IN6 / H633** smartphone (MediaTek MT6763 / Helio P23 SoC).

---

## Key Research Findings

### 1. Mainline Linux Feasibility on MT6763
- **Feasibility**: **HIGH**.
- **Evidence**: The MT6763 SoC is actively maintained in the `mtk-mainline/mt6763` kernel repository and runs in production on the Volla Phone 2020 (`mt6763v-volla-yggdrasil`).
- **Target Kernel**: **Linux 6.1 LTS** (via `linux-postmarketos-mediatek-mt6763` reference).
- **Bootloader State**: Unlocked (`unlocked: yes`, `secure: no`).

---

### 2. Component Readiness Matrix
- **Supported / Out-of-the-Box**: CPU (8x A53 / PSCI), RAM, GIC-v3, eMMC 5.1 (`mtk-sd`), USB 2.0 / OTG (`mtu3`), GPU (Mali-G71 via Panfrost), PMIC (MT6358), Pinctrl / GPIO, I2C, SPI, UART, Thermal, Vibrator.
- **Partially Supported (Requires IN6 DTS Mapping)**: MIPI DSI Display (MTK DRM driver present, needs IN6 panel init sequence), Audio (MT6358 ALSA codec present, needs sound card DTS), Battery / Charger (`mtk_battery`), Suspend / Resume (PSCI deep sleep).
- **Requires Firmware / Driver Porting**: Wi-Fi (`wlan_drv_gen2.ko` / MT6631 firmware), Bluetooth (`btmtkuart` / `stpbt.bin`), GPS (`gps_drv.ko`).
- **Problematic / High Risk**: Cellular Modem (MediaTek CCCI protocol requires custom port or `ofono`/`ModemManager` integration), Front & Rear Cameras (Proprietary MTK ISP 3.0 / V4L2 subdev configuration).
- **Unknown Hardware (Requires Board Identification)**: Touchscreen IC, Proximity / Light Sensor, Accelerometer / Gyroscope / Magnetometer, Fingerprint Controller, Charger IC.

---

### 3. Reusability of Existing Implementations
- **Volla Phone 2020**: Reusable SoC nodes (`mt6763.dtsi`), MT6358 PMIC wrapper, Panfrost GPU bindings, eMMC storage parameters, kernel configuration defaults.
- **UMIDIGI Breeze / A5 Pro**: Comparative MediaTek 4.4 vendor DTS structure, pinmux comparisons, sensor and camera kernel module parameter references.
- **Stock TECNO IN6 Kernel (4.4.95)**: Exact block partition offsets, GPIO keypad mappings (`mtk-kpd`), kernel command line parameters, stock module names.

---

### 4. Minimum Viable Boot Strategy (Phase 1)
1. Decompile stock `boot.img` and `odmdtbo.img` to extract panel timings and DTS nodes.
2. Build Linux 6.1 kernel compiled with `mt6763-tecno-in6.dts`.
3. Package kernel + initramfs (BusyBox shell) into standard Android `boot.img` header format.
4. Execute `fastboot boot boot.img` (tethered boot without flashing internal partitions).
5. Verify early console logs via USB serial gadget (`/dev/ttyGS0`).

---

### 5. Risk Assessment & Mitigations
- **Bricking Risk**: **ZERO** during Phase 1 research. Flashing commands (`fastboot flash`, `erase`, `format`) are strictly disabled in tooling.
- **Display Panel Incompatibility**: Decompile stock DTB/DTBO to recover exact MIPI DSI display commands and timings.
- **Touchscreen Non-Responsiveness**: Run user-space I2C bus scanner tool (`i2cdetect`) from minimal shell to identify touch controller slave address.
- **Modem Connectivity**: Cellular modem bring-up deferred to later phase; initial focus remains on local UI, Wi-Fi, and native Linux desktop environment.
