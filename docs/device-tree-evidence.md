# IN6 Device Tree Evidence & Source Classification Report

## Overview
This document records the evidence classification for every major node in `device/tecno/in6/dts/mt6763-tecno-in6.dts` and `mt6763-tecno-in6.dtsi`.

---

## Node Evidence Classification Table

| Device Tree Node | Classification Status | Primary Evidence Source | Parameter Detail |
|---|---|---|---|
| `compatible` | **CONFIRMED FROM DEVICE** | `getprop`: `ro.product.model`, `ro.hardware` | `"tecno,in6"`, `"mediatek,mt6763"` |
| `memory@40000000` | **CONFIRMED FROM DEVICE** | System Memory Telemetry | 3GB LPDDR RAM (`reg = <0x0 0x40000000 0x0 0xc0000000>`) |
| `chosen` / `bootargs` | **CONFIRMED FROM DRIVER** | Stock Kernel Command Line | `earlycon=uart8250,mmio32,0x11002000 console=ttyS0,115200n8 root=/dev/mmcblk0p33` |
| `serial@11002000` (`uart0`) | **CONFIRMED FROM DRIVER** | Stock TTY Driver / UART Address | MT6763 UART0 controller at `0x11002000` |
| `mmc@11230000` (`mmc0`) | **CONFIRMED FROM DEVICE** | `/proc/partitions` (`mmcblk0`) | MT6763 eMMC Host Controller at `0x11230000` |
| `gpio-keys` | **CONFIRMED FROM DEVICE** | `/proc/bus/input/devices` | `mtk-kpd` & `pmic_keys` event drivers |
| `pinctrl@10005000` (`pio`) | **INFERRED FROM MT6763** | MT6763 Register Memory Map | MT6763 GPIO / Pinctrl controller base at `0x10005000` |
| `i2c@11007000` (`i2c0`) | **INFERRED FROM MT6763** | MT6763 Register Memory Map | MT6763 I2C0 bus controller base at `0x11007000` |
| `touchscreen@0` | **PLACEHOLDER / UNKNOWN** | Missing I2C Bus Scan | Touch IC model & slave address **UNMEASURED** (`REQUIRES_IN6_MEASUREMENT`) |
| MIPI DSI Panel | **PLACEHOLDER / UNKNOWN** | Missing Panel DTB Dump | DSI panel timings & init sequence **UNMEASURED** |
