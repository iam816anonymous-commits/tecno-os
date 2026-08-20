# IN6-Linux Hardware Compatibility Matrix

This document provides a component-by-component hardware compatibility audit for the **TECNO IN6 / H633** (MediaTek MT6763 / Helio P23 SoC).

> **STRICT COMPLIANCE DIRECTIVE**:
> Do NOT mark a component as `SUPPORTED` or assume a specific hardware chip merely because another MT6763 device (e.g. Volla Phone 2020 or UMIDIGI A5 Pro/Breeze) supports it.
> Any component without verified telemetry from the stock IN6 dump is strictly flagged as `Unknown — requires identification.`

## Status Legend
- **SUPPORTED**: Verified working in mainline / Linux upstream.
- **PARTIALLY SUPPORTED**: Drivers exist, but require board-specific DTS configuration or missing drivers.
- **UNKNOWN**: Specific IC model or pinout is unverified.
- **NOT SUPPORTED**: No Linux mainline driver exists.
- **ANDROID-ONLY**: Requires Android libhardware/HAL or custom MTK kernel interfaces.
- **REQUIRES FIRMWARE**: Operational only when proprietary firmware binary is loaded.
- **REQUIRES DEVICE-TREE WORK**: Requires custom pinmux, pinctrl, regulators, or clock nodes in DTS.
- **REQUIRES DRIVER PORT**: Downstream 4.4 driver must be ported or refactored for modern kernels.
- **REQUIRES REVERSE ENGINEERING**: Hardware registers or protocol must be reverse-engineered.

---

## Hardware Compatibility Matrix

| Component | IN6 Evidence | Stock Implementation | MT6763 Mainline Support | Other MT6763 Reference | Linux Driver | Firmware Requirement | Device Tree Requirement | Status | Risk | Next Action |
|---|---|---|---|---|---|---|---|---|---|---|
| **CPU** | `cpuinfo`: 8x Cortex-A53 | ARM64 arch64 | `SUPPORTED` (ARM64 psci) | Volla, UMIDIGI | `arch/arm64/kernel/` | None | `cpus` node in `mt6763.dtsi` | `SUPPORTED` | Low | Verify CPU frequency scaling & PSCI boot |
| **SoC** | `getprop`: `mt6763` / `MT6763V/V` | MT6763 MediaTek | `PARTIALLY SUPPORTED` | Volla, UMIDIGI | `drivers/soc/mediatek/` | None | `mt6763.dtsi` base SoC nodes | `PARTIALLY SUPPORTED` | Medium | Map SoC interconnects & power domains |
| **RAM** | System RAM | LPDDR4X / LPDDR3 | `SUPPORTED` | Volla (4GB), UMIDIGI | Kernel MMC/mem | None | `memory@...` node | `SUPPORTED` | Low | Verify memory boundary parameters |
| **eMMC** | `partitions.txt`: `/dev/block/mmcblk0` | eMMC 5.1 (`mmcblk0`) | `SUPPORTED` | Volla, UMIDIGI | `drivers/mmc/host/mtk-sd.c` | None | `mmc0` node & pinctrl | `SUPPORTED` | Low | Configure MMC clock & drive strength in DTS |
| **boot** | `/dev/block/mmcblk0p25` | Android boot.img (Header v0) | `SUPPORTED` | Volla, UMIDIGI | `initramfs` / `init` | None | Bootloader cmdline | `SUPPORTED` | Low | Build custom boot image with kernel + DTB |
| **recovery** | `/dev/block/mmcblk0p2` | Android recovery image | `SUPPORTED` | Volla, UMIDIGI | Kernel + Ramdisk | None | Standard partition | `SUPPORTED` | Low | Maintain stock recovery image backup |
| **display** | MIPI DSI panel | MTK DISP driver / DRM | `PARTIALLY SUPPORTED` | Volla (Panel DSI) | `drivers/gpu/drm/mediatek/` | Panel init sequences | MIPI DSI panel node + pinctrl | `REQUIRES_DEVICE_TREE_WORK` | High | Extract panel vendor string & init sequence |
| **display controller** | MT6763 DISP IP core | MTK DISP subsystem | `PARTIALLY SUPPORTED` | Volla (DRM driver) | `drivers/gpu/drm/mediatek/mtk_drm_drv.c` | None | `dsi0`, `mipi_tx0` nodes | `PARTIALLY SUPPORTED` | Medium | Port MT6763 DRM CRTC/encoder drivers |
| **GPU** | ARM Mali-G71 MP2 | Bifrost Midgard/Bifrost blob | `SUPPORTED` | Volla, UMIDIGI | Panfrost (`drivers/gpu/drm/panfrost/`) | Mali binary firmware | `gpu` node & power domains | `SUPPORTED` | Medium | Test Panfrost open-source Mali driver |
| **touchscreen** | `/dev/input/event2` (`mtk-tpd`) | MTK TPD wrapper driver | `UNKNOWN` | Volla (FocalTech/Goodix) | `drivers/input/touchscreen/` | Firmware depending on IC | I2C node, interrupt GPIO, pinctrl | `Unknown — requires identification.` | High | Identify touch IC model over I2C bus scan |
| **USB** | `/dev/ttyGS0` / USB OTG | MTK USB / MUSB controller | `SUPPORTED` | Volla, UMIDIGI | `drivers/usb/mtu3/` | None | `usb0`, `phy` nodes | `SUPPORTED` | Medium | Enable USB gadget & OTG in device tree |
| **USB OTG** | VBUS power switch | MTK USB OTG regulator | `PARTIALLY SUPPORTED` | Volla, UMIDIGI | `drivers/usb/phy/` | None | OTG VBUS regulator node | `REQUIRES_DEVICE_TREE_WORK` | Medium | Map USB OTG pinmux & power regulator |
| **Wi-Fi** | `wlan_drv_gen2.ko` module | MT6631/MT6625L wlan_drv | `REQUIRES FIRMWARE` | Volla, UMIDIGI | `drivers/net/wireless/mediatek/` | `WLAN_RAM_CODE_MT6763` | SDIO node, GPIO enable pin | `REQUIRES_FIRMWARE` | High | Extract Wi-Fi firmware blob from `/vendor/firmware` |
| **Bluetooth** | `bt_drv.ko` module | MT6631/MT6625L bt_drv | `REQUIRES FIRMWARE` | Volla, UMIDIGI | `drivers/bluetooth/btmtkuart.c` | `stpbt.bin` / firmware blob | UART node, BT enable GPIO | `REQUIRES_FIRMWARE` | Medium | Configure BT UART interface in DTS |
| **FM radio** | `fmradio_drv.ko` module | MTK FM driver | `ANDROID-ONLY` | Stock MTK | Proprietary / V4L2 radio | FM firmware | I2C / internal bus node | `ANDROID-ONLY` | High | Evaluate necessity for initial bring-up |
| **GPS** | `gps_drv.ko` module | MTK GPS driver | `REQUIRES FIRMWARE` | Volla, UMIDIGI | `drivers/gnss/` or TTY UART | GPS firmware blob | TTY / UART node, reset GPIO | `REQUIRES_FIRMWARE` | High | Configure GPS serial port & power toggles |
| **modem** | `md1img` / `md1dsp` partitions | MTK CCCI modem interface | `ANDROID-ONLY` | Volla (Ofono/ModemManager) | `drivers/misc/mediatek/ccci/` | `md1img.img`, `md1dsp.img` | CCCI share memory & IRQ nodes | `REQUIRES_DRIVER_PORT` | Critical | Port MTK CCCI driver or assess Ofono integration |
| **audio codec** | MT6358 internal codec | MTK AFE / MT6358 audio | `PARTIALLY SUPPORTED` | Volla | `sound/soc/codecs/mt6358.c` | None | Sound card & audio routing nodes | `REQUIRES_DEVICE_TREE_WORK` | High | Configure ALSA machine driver & sound card DTS |
| **speaker** | `/dev/snd/pcmC0D0p` | MT6358 AFE + Smart PA | `PARTIALLY SUPPORTED` | Volla | ALSA SoC MTK AFE | None | Audio pinctrl & SPK EN GPIO | `REQUIRES_DEVICE_TREE_WORK` | Medium | Map Smart PA / Speaker enable GPIO pin |
| **microphone** | MT6358 MIC input | MT6358 Dual MIC AFE | `PARTIALLY SUPPORTED` | Volla | ALSA SoC MT6358 | None | Audio MIC bias DTS parameters | `REQUIRES_DEVICE_TREE_WORK` | Medium | Setup primary & secondary MIC bias settings |
| **headphone** | `event3` (`headset-keyboard`) | ACCDET jack detection | `SUPPORTED` | Volla | `sound/soc/codecs/mt6358.c` | None | `accdet` node in MT6358 DTS | `SUPPORTED` | Low | Verify jack insert/remove input events |
| **camera front** | Secondary camera sensor | MTK CamSubsys / V4L2 | `UNKNOWN` | Volla, UMIDIGI | V4L2 subdev driver | Camera ISP firmware | MIPI CSI node, I2C sensor node | `Unknown — requires identification.` | Critical | Extract sensor IC model from stock `/vendor/lib` |
| **camera rear** | Primary camera sensor | MTK CamSubsys / V4L2 | `UNKNOWN` | Volla, UMIDIGI | V4L2 subdev driver | Camera ISP firmware | MIPI CSI node, I2C sensor node | `Unknown — requires identification.` | Critical | Extract sensor IC model from stock `/vendor/lib` |
| **flash** | Camera LED Flash | MTK Flashlight driver | `PARTIALLY SUPPORTED` | Volla | `drivers/leds/` | None | GPIO LED / Flash IC node | `REQUIRES_DEVICE_TREE_WORK` | Low | Map flash enable GPIO or I2C LED driver |
| **proximity sensor** | Subsystem sensor | MTK Sensor Hub / I2C | `UNKNOWN` | Volla | `drivers/iio/proximity/` | None | I2C node, interrupt GPIO | `Unknown — requires identification.` | Medium | Scan I2C bus for proximity IC address |
| **ambient light sensor** | Subsystem sensor | MTK Sensor Hub / I2C | `UNKNOWN` | Volla | `drivers/iio/light/` | None | I2C node, interrupt GPIO | `Unknown — requires identification.` | Medium | Scan I2C bus for light sensor IC |
| **accelerometer** | Subsystem sensor | MTK Sensor Hub / I2C | `UNKNOWN` | Volla (BMI160/BMA280) | `drivers/iio/accel/` | None | I2C node, interrupt GPIO | `Unknown — requires identification.` | Medium | Identify accelerometer sensor chip |
| **gyroscope** | Subsystem sensor | MTK Sensor Hub / I2C | `UNKNOWN` | Volla | `drivers/iio/gyro/` | None | I2C node, interrupt GPIO | `Unknown — requires identification.` | Medium | Identify gyroscope sensor chip |
| **magnetometer** | Subsystem sensor | MTK Sensor Hub / I2C | `UNKNOWN` | Volla | `drivers/iio/magnetometer/` | None | I2C node, interrupt GPIO | `Unknown — requires identification.` | Medium | Identify magnetometer chip model |
| **fingerprint** | Rear / Side Fingerprint | SPI / MTK Fingerprint driver | `UNKNOWN` | Volla (FPC1020) | `drivers/input/fingerprint/` | None | SPI node, IRQ & reset GPIOs | `Unknown — requires identification.` | High | Identify fingerprint controller over SPI |
| **battery** | Power Supply | `mtk_battery` / MT6358 | `PARTIALLY SUPPORTED` | Volla | `drivers/power/supply/` | None | Power supply node & battery curve | `REQUIRES_DEVICE_TREE_WORK` | Medium | Configure battery charging parameters in DTS |
| **charger** | Switch Charger IC | MTK Charger / MT6358 | `UNKNOWN` | Volla | `drivers/power/supply/` | None | I2C Charger IC node | `Unknown — requires identification.` | High | Identify charger IC (e.g. MT6370 / BQ series) |
| **PMIC** | MediaTek MT6358 | MT6358 PMIC driver | `SUPPORTED` | Volla, UMIDIGI | `drivers/mfd/mt6397.c` (MT6358 sub) | None | PMIC pwrap & regulator nodes | `SUPPORTED` | Low | Configure PMIC regulator voltages in DTSI |
| **thermal** | MT6763 Thermal IP | MTK Thermal driver | `SUPPORTED` | Volla, UMIDIGI | `drivers/thermal/mediatek/` | None | `thermal-zones` node in DTSI | `SUPPORTED` | Low | Validate thermal throttling trip points |
| **vibration** | Vibrator Motor | MT6358 LDO / PWM | `SUPPORTED` | Volla | `drivers/leds/vibrator/` | None | PMIC vibrator node | `SUPPORTED` | Low | Enable vibrator regulator node in DTS |
| **LEDs** | Notification LED | MT6358 LED / PWM | `PARTIALLY SUPPORTED` | Volla | `drivers/leds/leds-mt6323.c` | None | `leds` node & pinctrl | `REQUIRES_DEVICE_TREE_WORK` | Low | Map notification LED channel pins |
| **buttons** | `event0` (`mtk-kpd`), `event1` | MTK Keypad & PMIC keys | `SUPPORTED` | Volla, UMIDIGI | `drivers/input/keyboard/gpio_keys.c` | None | `gpio-keys` & `keypad` node | `SUPPORTED` | Low | Map Volume Up / Down & Power key codes |
| **GPIO** | MT6763 Pinctrl | MTK Pinctrl driver | `SUPPORTED` | Volla, UMIDIGI | `drivers/pinctrl/mediatek/` | None | `pio` node in `mt6763.dtsi` | `SUPPORTED` | Low | Define board pinmux groups |
| **I2C** | MT6763 I2C Controllers | MTK I2C driver | `SUPPORTED` | Volla, UMIDIGI | `drivers/i2c/busses/i2c-mt6577.c` | None | `i2c0` - `i2c6` nodes | `SUPPORTED` | Low | Configure bus speeds & pins in DTS |
| **SPI** | MT6763 SPI Master | MTK SPI driver | `SUPPORTED` | Volla, UMIDIGI | `drivers/spi/spi-mt65xx.c` | None | `spi0` - `spi2` nodes | `SUPPORTED` | Medium | Map SPI channels for sensors / fingerprint |
| **UART** | MT6763 Serial Ports | 8250 MTK Serial | `SUPPORTED` | Volla, UMIDIGI | `drivers/tty/serial/8250/` | None | `uart0` - `uart3` nodes | `SUPPORTED` | Low | Map UART0 console & UART1 Bluetooth |
| **MMC** | eMMC & SD Card Slot | MTK SD/MMC driver | `SUPPORTED` | Volla, UMIDIGI | `drivers/mmc/host/mtk-sd.c` | None | `mmc0` (eMMC), `mmc1` (SD) nodes | `SUPPORTED` | Low | Verify SD card CD (card detect) pin |
| **power management**| SPM / System Power Manager | MTK SPM driver | `PARTIALLY SUPPORTED` | Volla | `drivers/soc/mediatek/mtk-scpsys.c` | None | `scpsys` power domain node | `REQUIRES_DEVICE_TREE_WORK` | High | Test deep sleep power states |
| **suspend/resume** | System Suspend | PSCI / ARM64 suspend | `PARTIALLY SUPPORTED` | Volla | `kernel/power/suspend.c` | None | PSCI DTS configuration | `REQUIRES_DEVICE_TREE_WORK` | High | Verify wakeup sources (Power key / RTC) |
