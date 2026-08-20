# IN6 Hardware Bring-Up Level Progression Matrix

## Overview
This matrix tracks the 17-level hardware bring-up order (Level 0 through Level 16) for the **TECNO IN6 / H633** (MediaTek MT6763).

---

## Hardware Bring-Up Order Table

| Level # | Hardware Milestone | Primary Target Component | Evidence Source / Status | Classification |
|---|---|---|---|---|
| **Level 0** | Bootloader Interaction | MediaTek LK v0.5 Fastboot | `fastboot getvar product` -> `IN6_H633` | **[CONFIRMED]** |
| **Level 1** | Early Kernel Execution | ARM64 CPU / PSCI / UART0 | `earlycon=uart8250,mmio32,0x11002000` | **[CONFIRMED]** |
| **Level 2** | Initramfs Execution | Gzip cpio initramfs in RAM | `/init` diagnostic script execution | **[WORKING]** |
| **Level 3** | Storage Initialization | eMMC 5.1 (`mmc0` at `0x11230000`)| `/dev/mmcblk0p33` ext4/f2fs mount | **[PROTOTYPE]** |
| **Level 4** | Display Subsystem | MIPI DSI Panel / DRM KMS | MIPI DSI panel timings | **[REQUIRES_IN6_MEASUREMENT]** |
| **Level 5** | Touchscreen Input | I2C Touch Controller (`event2`) | I2C0 slave address scan | **[REQUIRES_IN6_MEASUREMENT]** |
| **Level 6** | USB Connectivity | Micro-USB MTU3 PHY | CDC ACM `/dev/ttyGS0` gadget | **[PROTOTYPE]** |
| **Level 7** | Power & PMIC | MediaTek MT6358 PMIC | `schedutil` cpufreq & battery supply | **[PROTOTYPE]** |
| **Level 8** | Audio Subsystem | MT6358 Internal Codec / ALSA | Speaker / 3.5mm Headphone Jack | **[LIKELY]** |
| **Level 9** | Wireless Connectivity | MT6631 Wi-Fi & Bluetooth | Firmware `WLAN_RAM_CODE_MT6763` | **[LIKELY]** |
| **Level 10**| GPS / Location | MT6631 GPS Core | TTY NMEA sentence parsing | **[LIKELY]** |
| **Level 11**| Camera Subsystem | MIPI CSI Front/Rear CMOS | MT6763 ISP 3.0 / V4L2 subdev | **[UNKNOWN]** |
| **Level 12**| Cellular Modem | MT6763 Baseband CCCI | `md1img` firmware / ModemManager | **[INFERRED]** |
| **Level 13**| GPU Acceleration | ARM Mali-G71 MP2 | Panfrost DRM driver (`/dev/dri/card0`) | **[LIKELY]** |
| **Level 14**| Mobile Userspace | Wayfire / Phosh Wayland UI | Touch UI compositor rendering | **[PLANNED]** |
| **Level 15**| Security & Isolation | AppArmor / Permission Broker | Capability enforcement | **[PLANNED]** |
| **Level 16**| Daily-Driver Release | Complete IN6 Mobile System | 72-hr continuous stress stability | **[PLANNED]** |
