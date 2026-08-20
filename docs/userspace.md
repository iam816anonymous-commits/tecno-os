# IN6-Linux Userspace Architecture Design

## Architecture Principles
IN6-Linux uses a lightweight, modular, native Linux userspace stack. It eliminates the Android userspace framework (libhardware, HALs, SurfaceFlinger, ART, Bionic).

---

## Userspace Component Matrix

```
+-----------------------------------------------------------+
|                     Mobile UI / Shell                     |
|                 (Phosh / Plasma Mobile / Custom GTK)      |
+-----------------------------------------------------------+
|                    Display Compositor                     |
|              (Wayland Compositor / Sway / Wayfire)        |
+-----------------------------------------------------------+
|                   Hardware Services & IPC                 |
|       (NetworkManager / PipeWire / ModemManager / D-Bus)  |
+-----------------------------------------------------------+
|              Service Manager / Device Supervision         |
|                     (s6 / runit / udev)                   |
+-----------------------------------------------------------+
|                      Init Subsystem                       |
|                       (s6-linux-init / BusyBox)           |
+-----------------------------------------------------------+
|                   Standard C Library                      |
|                       (musl / glibc)                      |
+-----------------------------------------------------------+
```

---

## Technical Stack Selection

- **C Library**: `musl` (chosen for low memory footprint, speed, and strict POSIX compliance).
- **Core Utilities**: `BusyBox` for early initramfs; standard GNU/Alpine tools for rootfs.
- **Service Supervisor**: `s6` or `runit` for process supervision and dependency management.
- **Display Protocol**: Native **Wayland** running over DRM/KMS (`/dev/dri/card0`).
- **Audio Server**: **PipeWire** / **WirePlumber** over ALSA.
