# IN6-Linux Master OS Phased Engineering Roadmap

## Overview
This document outlines the 20-phase engineering roadmap (Phase 0 through Phase 19) for bringing **IN6-Linux** from initial bring-up to a daily-driver mobile operating system on the **TECNO IN6 / H633** (MediaTek MT6763).

Every milestone defines: Goal, Dependencies, Implementation Details, Tests, Success/Failure Criteria, Hardware Requirements, Recovery Strategy, and Implementation Status.

---

## Roadmap Phases Summary & Implementation Status

| Phase | Milestone Name | Implementation Status |
|---|---|---|
| **Phase 0** | Hardware Research & Baseline Audit | **[IMPLEMENTED]** |
| **Phase 1** | Candidate Kernel & DTB Bring-Up Build | **[IMPLEMENTED]** |
| **Phase 2** | UART / Serial Console Observability | **[PROTOTYPE]** |
| **Phase 3** | Storage & eMMC Filesystem Mount | **[PROTOTYPE]** |
| **Phase 4** | DRM/KMS Display & MIPI DSI Panel | **[PLANNED]** |
| **Phase 5** | Touchscreen Input & Evdev Subsystem | **[PLANNED]** |
| **Phase 6** | Hardware Keys & Button Input | **[PROTOTYPE]** |
| **Phase 7** | Audio Codec & PipeWire Sound Stack | **[PLANNED]** |
| **Phase 8** | USB OTG Host & CDC ACM Gadget | **[PROTOTYPE]** |
| **Phase 9** | Wi-Fi & Bluetooth Firmware Enablement | **[PLANNED]** |
| **Phase 10** | IIO Sensors (Accel, Gyro, Light, Prox) | **[PLANNED]** |
| **Phase 11** | Camera Subsystem & V4L2 Pipeline | **[PLANNED]** |
| **Phase 12** | GPS / GNSS Location Subsystem | **[PLANNED]** |
| **Phase 13** | Cellular Modem, Voice Calls & SMS | **[PLANNED]** |
| **Phase 14** | System Power & Battery Management | **[PLANNED]** |
| **Phase 15** | Mobile UI & Wayland Compositor | **[PLANNED]** |
| **Phase 16** | Permission Broker & Security Sandboxing | **[PLANNED]** |
| **Phase 17** | Native Linux Core Applications | **[PLANNED]** |
| **Phase 18** | Android Compatibility Layer (Waydroid) | **[PLANNED]** |
| **Phase 19** | Daily-Driver Stabilization & Release | **[PLANNED]** |

---

## Detailed Milestone Specifications

### Phase 0: Hardware Research & Baseline Audit
- **Goal**: Audit stock device telemetry, capture `/proc/config.gz`, map eMMC partitions, and audit MT6763 reference repositories.
- **Status**: **[IMPLEMENTED]**
- **Dependencies**: Physical TECNO IN6 device, ADB access.
- **Implementation**: Authored `docs/hardware-compatibility.md`, `inventory/` baseline, and `research/` comparative analysis.
- **Tests**: `tests/host/test_inventory.py`.
- **Success Criteria**: 100% of inventory files populated with verified telemetry.
- **Failure Criteria**: Missing stock configuration or unmapped block devices.
- **Hardware Requirements**: TECNO IN6 running stock Android 8.1.
- **Recovery Strategy**: Non-destructive ADB read-only commands.

---

### Phase 1: Candidate Kernel & DTB Bring-Up Build
- **Goal**: Create reproducible build pipeline for Linux kernel, `mt6763-tecno-in6.dtb`, minimal initramfs, and Android Header v0 `boot.img`.
- **Status**: **[IMPLEMENTED]**
- **Dependencies**: Phase 0 completion, GCC cross-toolchain, `dtc`, `cpp`.
- **Implementation**: Scripts in `build/` (`build-kernel.sh`, `build-rootfs.sh`, `build-image.sh`, `verify.sh`) and inspection tools in `tools/boot/`.
- **Tests**: `tests/host/test_kernel_build.py`, `test_boot_image.py`, `test_boot_safety.py`.
- **Success Criteria**: Candidate `boot.img` generated and validated by `tools/boot/validate_boot_image.py`.
- **Failure Criteria**: Build script failure or header validation mismatch.
- **Hardware Requirements**: Host Linux build PC.
- **Recovery Strategy**: Non-destructive host-side compilation.

---

### Phase 2: UART / Serial Console Observability
- **Goal**: Verify early kernel console output (`earlycon=uart8250,mmio32,0x11002000`) over USB serial gadget or UART0.
- **Status**: **[PROTOTYPE]**
- **Dependencies**: Phase 1 candidate `boot.img`, unlocked IN6 bootloader.
- **Implementation**: Command line `earlycon` configured in `mt6763-tecno-in6.dtsi` and `docs/testing/uart-observability.md`.
- **Tests**: Tethered boot physical log capture (`fastboot boot`).
- **Success Criteria**: Kernel writes early boot strings (`Booting Linux on physical CPU`) to serial/USB output.
- **Failure Criteria**: Silent crash or bootloader rejection.
- **Hardware Requirements**: TECNO IN6 + USB cable.
- **Recovery Strategy**: Force reboot (`Power + Vol Down`) to return to stock Android.

---

### Phase 3: Storage & eMMC Filesystem Mount
- **Goal**: Initialize MT6763 eMMC host controller (`mmc0` at `0x11230000`) and mount ext4 system and f2fs userdata partitions.
- **Status**: **[PROTOTYPE]**
- **Dependencies**: Phase 2 kernel console handoff.
- **Implementation**: `CONFIG_MMC_MTK=y`, `CONFIG_EXT4_FS=y`, `CONFIG_F2FS_FS=y` in `in6-stock-defconfig`.
- **Tests**: Initramfs script checks `/proc/partitions` and block devices.
- **Success Criteria**: Kernel detects `/dev/mmcblk0` and mounts `/dev/mmcblk0p33` cleanly.
- **Failure Criteria**: Kernel panic during MMC probe or storage driver timeout.
- **Hardware Requirements**: IN6 eMMC 5.1 storage.
- **Recovery Strategy**: Read-only mount test without modifying partition headers.

---

### Phase 4: DRM/KMS Display & MIPI DSI Panel
- **Goal**: Drive MIPI DSI panel via MediaTek DRM driver (`drivers/gpu/drm/mediatek/`) and display splash graphics.
- **Status**: **[PLANNED]**
- **Dependencies**: Phase 3 storage and panel init sequence extraction.
- **Implementation**: Add DSI panel timing nodes to `mt6763-tecno-in6.dts` and enable `CONFIG_DRM_MEDIATEK=y`.
- **Tests**: Display test pattern rendered directly to `/dev/dri/card0`.
- **Success Criteria**: Screen displays IN6-Linux graphical splash without artifacting.
- **Failure Criteria**: Black screen, DSI clock timeout, or panel bus fault.
- **Hardware Requirements**: IN6 MIPI DSI LCD panel.
- **Recovery Strategy**: Fallback to USB serial console logging if display fails.

---

### Phase 5: Touchscreen Input & Evdev Subsystem
- **Goal**: Identify touch IC slave address over I2C0, enable kernel driver, and process touch events.
- **Status**: **[PLANNED]**
- **Dependencies**: Phase 4 display bring-up.
- **Implementation**: I2C bus scan via `i2cdetect` to determine slave address, update `mt6763-tecno-in6.dts`.
- **Tests**: `evtest /dev/input/event2` captures X/Y touch coordinates.
- **Success Criteria**: Touch coordinates correctly map to display pixel resolution.
- **Failure Criteria**: Unresponsive touch interface or I2C communication error.
- **Hardware Requirements**: IN6 touch panel.
- **Recovery Strategy**: Hardware key navigation fallback.

---

### Phase 6: Hardware Keys & Button Input
- **Goal**: Process Volume Up, Volume Down, and Power key presses via `gpio-keys` and `pmic_keys`.
- **Status**: **[PROTOTYPE]**
- **Dependencies**: Phase 1 device tree gpio-keys node.
- **Implementation**: Configured `gpio-keys` in `mt6763-tecno-in6.dtsi` (`event0` and `event1`).
- **Tests**: `evtest /dev/input/event0` logs key press and release events.
- **Success Criteria**: Volume and Power key presses generate standard Linux keycodes (`KEY_VOLUMEUP`, `KEY_VOLUMEDOWN`, `KEY_POWER`).
- **Failure Criteria**: Unhandled interrupt or missing keycode mapping.
- **Hardware Requirements**: IN6 physical side buttons.
- **Recovery Strategy**: Serial console shell input.

---

### Phase 7: Audio Codec & PipeWire Sound Stack
- **Goal**: Initialize MT6358 internal audio codec, ALSA machine driver, and PipeWire audio routing.
- **Status**: **[PLANNED]**
- **Dependencies**: Phase 3 rootfs execution.
- **Implementation**: Enable `CONFIG_SND_SOC_MT6358=y`, configure ALSA sound card nodes in DTS, deploy PipeWire.
- **Tests**: `aplay` plays test WAV file to speaker and 3.5mm headphone jack.
- **Success Criteria**: Clear audio playback through speaker and headphones without distortion.
- **Failure Criteria**: ALSA codec probe failure or audio buffer underrun.
- **Hardware Requirements**: IN6 MT6358 audio codec + speaker/headphones.
- **Recovery Strategy**: Silent system operation during audio debugging.

---

### Phase 8: USB OTG Host & CDC ACM Gadget
- **Goal**: Support USB High-Speed CDC ACM serial gadget, MTP file transfer, and USB OTG host mode.
- **Status**: **[PROTOTYPE]**
- **Dependencies**: Phase 1 kernel USB configuration (`CONFIG_USB_MTU3=y`).
- **Implementation**: Configure `mtu3` USB controller in `mt6763-tecno-in6.dtsi`.
- **Tests**: Host PC detects `/dev/ttyGS0` serial interface and mounts MTP storage.
- **Success Criteria**: Two-way serial communication and file transfer over Micro-USB cable.
- **Failure Criteria**: USB PHY lockup or gadget enumeration failure.
- **Hardware Requirements**: Micro-USB port + USB OTG adapter.
- **Recovery Strategy**: Physical UART console fallback.

---

### Phase 9: Wi-Fi & Bluetooth Firmware Enablement
- **Goal**: Load MT6631 proprietary firmware binaries (`WLAN_RAM_CODE_MT6763` and `stpbt.bin`) to enable Wi-Fi and Bluetooth.
- **Status**: **[PLANNED]**
- **Dependencies**: Phase 3 filesystem mount and firmware extraction scripts.
- **Implementation**: Integrate `wlan_drv_gen2.ko` and `btmtkuart` drivers with local firmware extraction tool.
- **Tests**: `nmcli dev wifi list` discovers wireless access points; `bluetoothctl scan on` detects BT devices.
- **Success Criteria**: Stable Wi-Fi connection and Bluetooth pairability.
- **Failure Criteria**: Firmware load failure or SDIO bus timeout.
- **Hardware Requirements**: MT6631 Wi-Fi/BT combo chip.
- **Recovery Strategy**: Fully functional offline operation if wireless disabled.

---

### Phase 10: IIO Sensors (Accel, Gyro, Light, Prox)
- **Goal**: Enable Linux IIO drivers for accelerometer, gyroscope, ambient light, and proximity sensors over I2C/SPI.
- **Status**: **[PLANNED]**
- **Dependencies**: Phase 5 I2C bus scan identification.
- **Implementation**: Add sensor nodes to DTS, deploy `iio-sensor-proxy`.
- **Tests**: `monitor-sensor` reports real-time orientation changes and proximity state.
- **Success Criteria**: Automatic screen rotation and proximity display sleep during calls.
- **Failure Criteria**: Sensor read timeout or invalid IIO data scaling.
- **Hardware Requirements**: IN6 onboard sensor suite.
- **Recovery Strategy**: Manual screen orientation toggle.

---

### Phase 11: Camera Subsystem & V4L2 Pipeline
- **Goal**: Drive front and rear CMOS camera sensors via V4L2 subdev interfaces and MT6763 ISP 3.0 core.
- **Status**: **[PLANNED]**
- **Dependencies**: Phase 4 display and Phase 9 firmware loading.
- **Implementation**: Port MediaTek camera ISP drivers and MIPI CSI receiver bindings.
- **Tests**: `v4l2-ctl` captures test frame to local JPEG file; preview renders in camera application.
- **Success Criteria**: Clear video preview and photo capture from front and rear camera sensors.
- **Failure Criteria**: MIPI CSI packet error or ISP memory allocation failure.
- **Hardware Requirements**: IN6 front/rear camera modules + LED flash.
- **Recovery Strategy**: System operates normally with camera disabled.

---

### Phase 12: GPS / GNSS Location Subsystem
- **Goal**: Interface with MT6631 GPS core via TTY serial interface and provide location fixes to geolocation services.
- **Status**: **[PLANNED]**
- **Dependencies**: Phase 9 MT6631 firmware loading.
- **Implementation**: Deploy `geoclue2` / `gpsd` reading NMEA sentences from GPS TTY port.
- **Tests**: `cgps` displays latitude/longitude coordinates and satellite constellation fix.
- **Success Criteria**: Cold GPS fix achieved within 45 seconds outdoors.
- **Failure Criteria**: Serial framing error or satellite tracking failure.
- **Hardware Requirements**: MT6631 GPS receiver + antenna.
- **Recovery Strategy**: Offline manual location selection.

---

### Phase 13: Cellular Modem, Voice Calls & SMS
- **Goal**: Interface with MT6763 baseband modem via CCCI driver, `ModemManager`, and `ofono` for voice calls, SMS, and LTE data.
- **Status**: **[PLANNED]**
- **Dependencies**: Phase 7 audio, Phase 9 firmware, and CCCI driver porting.
- **Implementation**: Port MediaTek CCCI shared memory driver (`ccci`), configure `ModemManager` DBus service.
- **Tests**: Make test voice call (`mmcli -m 0 --voice-create-call`), send test SMS, verify LTE data connection.
- **Success Criteria**: Two-way voice audio, incoming/outgoing SMS processing, and mobile data packet routing.
- **Failure Criteria**: Modem crash, SIM detection failure, or CCCI memory buffer corruption.
- **Hardware Requirements**: IN6 SIM card slot + cellular network antenna.
- **Recovery Strategy**: Local Wi-Fi / offline system operation.

---

### Phase 14: System Power & Battery Management
- **Goal**: Implement system deep suspend (`mem`), CPU frequency scaling (`schedutil`), thermal throttling, and battery status reporting.
- **Status**: **[PLANNED]**
- **Dependencies**: Phase 3 storage, Phase 6 hardware keys, Phase 7 audio.
- **Implementation**: Deploy `upower` service reading MT6358 battery power supply nodes (`/sys/class/power_supply/mtk-battery`).
- **Tests**: Measure idle suspend battery drain (< 0.8% per hour); verify system resumes on Power Key press.
- **Success Criteria**: System enters deep sleep when screen is off and resumes instantly on key press or call.
- **Failure Criteria**: Suspend hang, battery drain > 2% per hour, or thermal panic.
- **Hardware Requirements**: MT6358 PMIC + IN6 battery.
- **Recovery Strategy**: Keep CPU active if suspend hangs during early power debugging.

---

### Phase 15: Mobile UI & Wayland Compositor
- **Goal**: Deploy touch-optimized Wayland compositor (Wayfire / Phosh) and mobile control panel UI.
- **Status**: **[PLANNED]**
- **Dependencies**: Phase 4 display, Phase 5 touch, Phase 14 power management.
- **Implementation**: Package Wayfire / Phosh compositor stack with custom dark/light mobile themes.
- **Tests**: Measure idle compositor RAM footprint (< 80 MB); verify touch gesture responsiveness.
- **Success Criteria**: Fluid 60fps touch UI navigation, app launcher, notification shade, and quick settings toggles.
- **Failure Criteria**: Compositor crash, GPU driver panic, or touch input offset.
- **Hardware Requirements**: Mali-G71 GPU (Panfrost driver) + touch panel.
- **Recovery Strategy**: Fallback to lightweight Weston compositor.

---

### Phase 16: Permission Broker & Security Sandboxing
- **Goal**: Deploy centralized IPC permission broker, AppArmor profiles, seccomp filters, and per-app network isolation.
- **Status**: **[PLANNED]**
- **Dependencies**: Phase 15 Mobile UI.
- **Implementation**: Implement Permission Broker daemon, AppArmor profiles for third-party apps, and nftables per-app network firewall.
- **Tests**: Verify blocked app cannot access `/dev/video0`, microphone PipeWire stream, or network sockets.
- **Success Criteria**: 100% enforcement of capability policies (ALLOW, DENY, ASK, ONE-TIME, WHILE-IN-USE).
- **Failure Criteria**: Permission bypass or kernel panic during cgroup/AppArmor enforcement.
- **Hardware Requirements**: Linux kernel LSM primitives.
- **Recovery Strategy**: Permissive debugging mode (`enforcing=0`) during development.

---

### Phase 17: Native Linux Core Applications
- **Goal**: Provide native offline GTK4 / Qt6 mobile core utilities (Terminal, Files, Settings, Contacts, Notes, Clock, Calculator, Camera, Gallery).
- **Status**: **[PLANNED]**
- **Dependencies**: Phase 15 Mobile UI, Phase 16 Permission Broker.
- **Implementation**: Package lightweight GTK4 / libadwaita and Qt6 / Kirigami mobile application suite.
- **Tests**: Launch and test all core utilities offline; verify resource budgets (< 1.2s app launch time).
- **Success Criteria**: Complete offline daily-driver utility without internet connectivity.
- **Failure Criteria**: Application startup crash or memory leakage exceeding RAM budget.
- **Hardware Requirements**: Complete IN6 hardware stack.
- **Recovery Strategy**: Fallback to terminal command-line tools.

---

### Phase 18: Android Compatibility Layer (Waydroid)
- **Goal**: Provide an optional containerized Android application subsystem using Waydroid and LXC containers.
- **Status**: **[PLANNED]**
- **Dependencies**: Phase 15 Mobile UI, Phase 16 Sandboxing.
- **Implementation**: Deploy Waydroid LXC container layer mapping Android display/audio to native Wayland/PipeWire.
- **Tests**: Launch common Android APK offline; verify container can be completely stopped and disabled from Settings.
- **Success Criteria**: Android applications execute smoothly inside container without compromising native Linux security.
- **Failure Criteria**: Container initialization hang or RAM consumption exceeding 1.2 GB.
- **Hardware Requirements**: 3GB LPDDR RAM + Panfrost GPU acceleration.
- **Recovery Strategy**: Disable Waydroid container; system remains 100% functional as native Linux OS.

---

### Phase 19: Daily-Driver Stabilization & Release
- **Goal**: Perform comprehensive system stabilization, battery drain optimization, security auditing, and reproducible image packaging.
- **Status**: **[PLANNED]**
- **Dependencies**: Phases 0 through 18.
- **Implementation**: Run 72-hour continuous stress testing, memory leak audits, and offline package verification.
- **Tests**: Execute full automated host and hardware test suite (`verify.sh`).
- **Success Criteria**: Zero kernel panics over 72 hours, idle RAM < 450 MB, battery drain < 0.8%/hr, 100% pass on all host tests.
- **Failure Criteria**: Unresolved memory leak, system instability, or permission enforcement bypass.
- **Hardware Requirements**: Final TECNO IN6 production device.
- **Recovery Strategy**: Roll back system update via local signed recovery image.
