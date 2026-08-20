# Linux Driver Subsystem Matrix for MT6763 & TECNO IN6

This matrix details driver subsystem mapping, Linux kernel module locations, and migration pathways from stock 4.4 Android drivers to Linux 6.1+ mainline drivers.

| Hardware Subsystem | Stock Android Driver (4.4) | Mainline Linux Driver (6.1+) | Subsystem Path | Migration Effort / Strategy |
|---|---|---|---|---|
| **CPU Core / PSCI** | `arch/arm64/kernel/psci.c` | `arch/arm64/kernel/psci.c` | `kernel/power` | **Native Support**: Standard ARM PSCI 1.0 interface. |
| **Pinctrl / GPIO** | `drivers/pinctrl/mediatek/pinctrl-mt6763.c` | `drivers/pinctrl/mediatek/pinctrl-mt6763.c` | `drivers/pinctrl` | **Mainline Native**: DT pinctrl groups must be mapped. |
| **Clock Subsystem** | `drivers/clocks/mtk_clk.c` | `drivers/clk/mediatek/clk-mt6763.c` | `drivers/clk` | **Mainline Native**: Integrated in `clk-mt6763.c`. |
| **PMIC / Regulators**| `drivers/regulator/mt6358-regulator.c` | `drivers/regulator/mt6358-regulator.c` | `drivers/regulator` | **Mainline Native**: MT6358 bindings present in 6.1. |
| **eMMC / SD Card** | `drivers/mmc/host/mtk-sd.c` | `drivers/mmc/host/mtk-sd.c` | `drivers/mmc` | **Mainline Native**: `mtk-sd` supports MT6763 eMMC. |
| **USB Controller** | `drivers/usb/mu3d/` | `drivers/usb/mtu3/mtu3_core.c` | `drivers/usb` | **Mainline Native**: `mtu3` driver supports USB OTG/Gadget. |
| **GPU (Mali-G71)** | `drivers/gpu/arm/midgard/` (Proprietary) | `drivers/gpu/drm/panfrost/` | `drivers/gpu/drm` | **Mainline Native**: Panfrost DRM driver. |
| **Display (DRM)** | `drivers/misc/mediatek/video/` (Legacy DISP) | `drivers/gpu/drm/mediatek/mtk_drm_drv.c` | `drivers/gpu/drm` | **Porting Required**: Panel DSI init script porting needed. |
| **Touchscreen** | `drivers/input/touchscreen/mediatek/` | `drivers/input/touchscreen/` | `drivers/input` | **Unknown IC**: Requires I2C bus scan to pick driver. |
| **Wi-Fi Subsystem** | `wlan_drv_gen2.ko` (Out-of-tree) | `drivers/net/wireless/mediatek/mt76/` | `drivers/net` | **Firmware Dependency**: Requires `WLAN_RAM_CODE`. |
| **Bluetooth** | `bt_drv.ko` (Out-of-tree) | `drivers/bluetooth/btmtkuart.c` | `drivers/bluetooth` | **Mainline Native**: `btmtkuart` handles MT6631 over UART. |
| **Modem (CCCI)** | `drivers/misc/mediatek/ccci/` | Out-of-tree / Custom Port | `drivers/misc` | **Complex Port**: Out-of-tree MTK CCCI port required. |
| **Audio (ALSA)** | `sound/soc/mediatek/mt6763/` | `sound/soc/mediatek/mt6358/` | `sound/soc` | **Mainline Native**: ALSA AFE + MT6358 machine driver. |
| **Sensors (IIO)** | `drivers/misc/mediatek/sensors-1.0/` | `drivers/iio/` | `drivers/iio` | **Standard IIO**: Standard Linux IIO drivers once IC identified. |
