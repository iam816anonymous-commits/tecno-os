# IN6 Hardware Subsystem Feature Status Matrix

## Overview
This document tracks the current status, driver dependency, device tree requirements, firmware dependencies, user-space requirements, and test procedures for every hardware feature on the **TECNO IN6 / H633** (MediaTek MT6763).

---

## Hardware Feature Matrix

| Feature | Linux Driver | Kernel Dependency | DT Dependency | Firmware Dependency | Userspace Dependency | Status Flag | Evidence Source | Test Procedure |
|---|---|---|---|---|---|---|---|---|
| **CPU Core** | `arch/arm64/kernel/psci.c` | `CONFIG_ARM64=y` | `cpus` node | None | libc / POSIX | **[CONFIRMED]** | `/proc/cpuinfo` (8x Cortex-A53) | `cat /proc/cpuinfo` |
| **RAM** | System Memory | `CONFIG_SPARSEMEM=y` | `memory@40000000` | None | Memory Manager | **[CONFIRMED]** | System Telemetry (3GB LPDDR) | `free -m` |
| **eMMC Storage** | `drivers/mmc/host/mtk-sd.c` | `CONFIG_MMC_MTK=y` | `mmc0: mmc@11230000` | None | `udev` / mount | **[CONFIRMED]** | `/proc/partitions` (`mmcblk0`) | `mount /dev/mmcblk0p33` |
| **UART Console** | `drivers/tty/serial/8250/` | `CONFIG_SERIAL_8250_MT6577=y` | `uart0: serial@11002000` | None | TTY Shell | **[CONFIRMED]** | Command line `earlycon` | `cat /dev/ttyS0` |
| **Buttons / Keys** | `drivers/input/keyboard/gpio_keys.c` | `CONFIG_KEYBOARD_GPIO=y` | `gpio-keys` node | None | `evdev` | **[CONFIRMED]** | `/proc/bus/input/devices` | `evtest /dev/input/event0` |
| **USB CDC Gadget** | `drivers/usb/mtu3/` | `CONFIG_USB_MTU3=y` | `usb0` PHY node | None | `adbd` / Serial | **[PROTOTYPE]** | `mtu3` controller in defconfig | USB CDC serial detection |
| **PMIC / Battery** | `drivers/regulator/mt6358-regulator.c` | `CONFIG_REGULATOR_MT6358=y` | `pwrap` & PMIC nodes | None | `upowerd` | **[PROTOTYPE]** | MT6358 driver in defconfig | `cat /sys/class/power_supply/*` |
| **Display Panel** | `drivers/gpu/drm/mediatek/` | `CONFIG_DRM_MEDIATEK=y` | DSI panel timings | None | Wayland Compositor | **[UNKNOWN]** | Unmeasured DSI panel parameters | Direct rendering to `/dev/dri/card0` |
| **Touchscreen** | `drivers/input/touchscreen/` | `CONFIG_INPUT_TOUCHSCREEN=y` | I2C touch node | None | `evdev` | **[UNKNOWN]** | `/dev/input/event2` (`mtk-tpd`) | `evtest /dev/input/event2` |
| **Wi-Fi** | `wlan_drv_gen2.ko` | Wireless Subsystem | SDIO node | `WLAN_RAM_CODE_MT6763` | `NetworkManager` | **[LIKELY]** | `/vendor/lib/modules/wlan_drv_gen2.ko` | `nmcli dev wifi list` |
| **Bluetooth** | `drivers/bluetooth/btmtkuart.c` | `CONFIG_BT_HCIUART=y` | UART1 BT node | `stpbt.bin` | `bluez` / `bluetoothctl` | **[LIKELY]** | `/vendor/lib/modules/bt_drv.ko` | `bluetoothctl scan on` |
| **Audio Codec** | `sound/soc/codecs/mt6358.c` | `CONFIG_SND_SOC_MT6358=y` | Audio AFE nodes | None | ALSA / PipeWire | **[CONFIRMED]** | MT6358 AFE in defconfig | `aplay test.wav` |
| **Sensors** | `drivers/iio/` | `CONFIG_IIO=y` | I2C sensor nodes | None | `iio-sensor-proxy` | **[UNKNOWN]** | Unmeasured sensor IC models | `monitor-sensor` |
| **Camera** | `drivers/media/platform/mtk-isp/` | V4L2 Subsystem | MIPI CSI nodes | ISP 3.0 Firmware | PipeWire / V4L2 | **[UNKNOWN]** | Unmeasured CMOS sensor ICs | `v4l2-ctl --stream-mmap` |
| **Cellular Modem** | `drivers/misc/mediatek/ccci/` | CCCI Driver Subsystem | CCCI share memory | `md1img` / `md1dsp` | `ModemManager` / `ofono` | **[INFERRED]** | `/dev/ccci*` interface in stock | `mmcli -m 0` |
