# MT6763 Technical Comparison & Device Tree Analysis

## Executive Summary
This document provides a comparative analysis of MediaTek MT6763 (Helio P23) device trees and hardware implementations across:
1. **Volla Phone 2020** (Mainline reference device: `mt6763v-volla-yggdrasil.dts`)
2. **UMIDIGI Breeze / A5 Pro** (Downstream / Lineage reference)
3. **TECNO IN6 / H633** (Target device)

## Common SoC Nodes vs Board-Specific Divergences

### Common MT6763 SoC Nodes (`mt6763.dtsi`)
These nodes are identical across all MT6763 platforms and defined in the upstream/mainline SoC DTSI:
- **CPU Topology**: 8x ARM Cortex-A53 cores (4x Little @ 1.5GHz, 4x Big @ 2.0GHz) with PSCI (`arm,psci-1.0`).
- **Memory Map & Interconnect**: APB/AXI bus structure, GIC-v3 interrupt controller (`10201000.interrupt-controller`).
- **Clocks & Topckgen**: Fixed clocks, `topckgen` (`10000000`), `infracfg` (`10001000`), `apmixedsys` (`1000c000`).
- **Pinctrl & GPIO**: `pio` (`10005000`) managing 177 GPIO pins.
- **Power Wrapper**: `pwrap` (`1000d000`) connecting CPU to MT6358 PMIC via PMIC Wrapper interface.
- **Peripherals**:
  - `i2c0` (`11007000`) - `i2c6` (`11013000`)
  - `spi0` (`1100a000`) - `spi2` (`11011000`)
  - `uart0` (`11002000`) - `uart3` (`11005000`)
  - `mmc0` (`11230000` - eMMC), `mmc1` (`11240000` - SD Card)
  - `dsi0` (`14014000`), `mipi_tx0` (`10215000`)
  - `gpu` (`13000000` - ARM Mali-G71 MP2)

---

### Board-Specific Divergences Matrix

| Component | Volla Phone 2020 | UMIDIGI Breeze | TECNO IN6 Target |
|---|---|---|---|
| **PMIC Interface** | MT6358 | MT6358 / MT6357 | MT6358 |
| **Display Panel** | MIPI DSI 6.3" 2340x1080 | MIPI DSI 6.3" 2280x1080 | MIPI DSI 6.0" (HD+/FHD+) |
| **Touchscreen** | FocalTech FT8719 / Goodix GT928 | FocalTech / Goodix | `Unknown — requires identification.` |
| **Wi-Fi / BT Combo**| MT6631 (SDIO / UART) | MT6625L / MT6631 | MT6631 / MT6625L |
| **Audio PA** | MT6358 AFE + NXP SmartPA | MT6358 AFE | MT6358 AFE |
| **Fingerprint** | FPC1020 SPI (`/dev/fpc1020`) | MicroArray / ChipOne | `Unknown — requires identification.` |
| **Sensors (I2C)** | Bosch BMI160, AK09918 | InvenSense / Bosch | `Unknown — requires identification.` |
| **Keypad** | GPIO Keys + PMIC Power Key | GPIO Keys + PMIC Power Key | `mtk-kpd` + PMIC Power Key |

---

## Required IN6 DTS Configuration

To boots strap MT6763 mainline for the TECNO IN6, the board DTS (`mt6763-tecno-in6.dts`) must populate:
1. `memory@40000000`: 3GB LPDDR memory mapping (`reg = <0x0 0x40000000 0x0 0xC0000000>`).
2. `chosen`: Boot arguments (`earlycon=uart8250,mmio32,0x11002000 console=ttyS0,115200n8 root=/dev/mmcblk0p33`).
3. `pinctrl` map: Assign pins for UART0, I2C0-I2C3, eMMC/SD, DSI, and PMIC keys.
4. `regulators`: Enable PMIC MT6358 regulators (`vproc`, `vcore`, `vmodem`, `vmc`, `vcn33`, `vio28`).
