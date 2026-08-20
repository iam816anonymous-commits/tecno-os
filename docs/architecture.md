# IN6-Linux System Architecture Overview

## Project Vision
IN6-Linux is a fully independent, native Linux operating system engineered specifically for the TECNO IN6 / H633 smartphone based on the MediaTek MT6763 (Helio P23) SoC.

**THIS IS NOT AN ANDROID DERIVATIVE (ROM).**
The project excludes Android runtime services, ART, SurfaceFlinger, Bionic libc, HALs, and Android framework binaries.

---

## Architecture Stack

```
+-------------------------------------------------------------+
|                 IN6 Mobile Shell / Apps                     |
|            (Wayland Compositor / GTK4 / Qt6)                |
+-------------------------------------------------------------+
|                 IPC & Desktop Services                      |
|           (D-Bus / NetworkManager / PipeWire)               |
+-------------------------------------------------------------+
|               Hardware Abstraction & Services               |
|          (ModemManager / Ofono / BlueZ / Iio-sensor-proxy)  |
+-------------------------------------------------------------+
|              Service Supervisor & Device Manager            |
|                   (s6 / runit / udev / mdev)                |
+-------------------------------------------------------------+
|                       Init Subsystem                        |
|                     (Custom Init / musl)                    |
+-------------------------------------------------------------+
|                    Linux Kernel (6.1 LTS)                   |
|               (MT6763 Mainline Drivers & DTS)               |
+-------------------------------------------------------------+
|                       IN6 Hardware                          |
|         (Cortex-A53 / Mali-G71 / MT6358 PMIC / eMMC)        |
+-------------------------------------------------------------+
```

---

## Core System Principles

1. **Native Linux Standards**: Standard Linux APIs (`/dev`, `/sys`, `/proc`, ALSA, DRM/KMS, v4l2, evdev, input_event).
2. **Modular Components**: Clean separation between kernel, init, hardware services, display server, and UI shell.
3. **Reproducible Builds**: Sealed containerized build pipeline generating image artifacts with verifiable SHA256 checksums.
4. **Source-Controlled Hardware**: Device tree files (`.dts` / `.dtsi`) define pinmux, clocks, regulators, and memory offsets.
5. **Upstream Path**: Continuous alignment with upstream Linux kernel (`mtk-mainline`) to eliminate proprietary Android blobs over time.
