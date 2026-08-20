# IN6 Hardware Overview & Specification Baseline

## Device Identity
- **Model**: TECNO IN6
- **Hardware Family**: H633 (`IN6_H633`)
- **Board Platform**: MediaTek MT6763 (Helio P23)

---

## Hardware Specifications Summary

### Processing Unit (SoC)
- **SoC**: MediaTek MT6763V/V (16nm FinFET process)
- **CPU**: 8x ARM Cortex-A53 cores (ARMv8-A 64-bit)
  - 4x Big Cores @ up to 2.0 GHz
  - 4x Little Cores @ up to 1.5 GHz
- **GPU**: ARM Mali-G71 MP2 @ 770 MHz (Supported by open-source Panfrost DRM driver)
- **Architecture**: `aarch64` / `arm64-v8a`

### Memory & Storage
- **RAM**: 3GB LPDDR4X / LPDDR3
- **Internal Storage**: 32GB eMMC 5.1 (`/dev/block/mmcblk0`)
- **External Storage**: MicroSD Card slot (`mmc1`)

### Display & Touch
- **Display Interface**: MIPI DSI (4-lane) via MediaTek DISP / DRM subsystem
- **Resolution**: 6.0-inch HD+ / FHD+ LCD
- **Touch Controller**: I2C-connected (`Unknown — requires identification.`)

### Connectivity Subsystem
- **Combo Chip**: MediaTek MT6631 / MT6625L
  - **Wi-Fi**: 802.11 a/b/g/n (2.4GHz / 5GHz) via `wlan_drv_gen2.ko`
  - **Bluetooth**: Bluetooth 4.2 LE via `bt_drv.ko`
  - **FM Radio**: Integrated receiver via `fmradio_drv.ko`
  - **GPS/GNSS**: GPS/GLONASS/Beidou via `gps_drv.ko`
- **USB**: USB 2.0 High-Speed with OTG (`mtu3` controller)

### Power & PMIC
- **Primary PMIC**: MediaTek MT6358
- **Power Wrapper**: MT6763 `pwrap` interface
- **Battery**: ~3050 mAh Li-ion battery

### Audio & Sound
- **Audio Codec**: MT6358 internal AFE codec
- **Outputs**: External Speaker (Smart PA), Earpiece, 3.5mm Headphone Jack (`ACCDET` detection)
- **Inputs**: Primary microphone + Secondary noise cancellation microphone
