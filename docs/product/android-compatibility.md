# IN6-Linux Android Compatibility Subsystem Architecture

## Architectural Principle
Android compatibility in **IN6-Linux** is designed strictly as an **OPTIONAL SUBSYSTEM LAYER** running on top of a native Linux operating system.

> **CRITICAL DIRECTIVE**:
> The underlying operating system is Linux. Android is **NOT** the base operating system.
> The user can completely disable or uninstall the Android compatibility layer without affecting core Linux OS functionality.

---

## Subsystem Architecture Stack

```
+-------------------------------------------------------------+
|                     Android Applications                    |
+-------------------------------------------------------------+
|             Waydroid LXC Container (Minimal Android)        |
|             (Android HALs mapped to Linux Wayland/ALSA)     |
+-------------------------------------------------------------+
|               Linux Hardware Bridge (libhybris)             |
+-------------------------------------------------------------+
|                  IN6-Linux Native Operating System          |
|            (Linux Kernel 6.1 / DRM / Wayland / PipeWire)    |
+-------------------------------------------------------------+
```

---

## User Control & Management
1. **On-Demand Activation**: Waydroid container processes are initialized only when an Android application is launched.
2. **One-Tap Termination**: User can kill the container and free all allocated RAM from the System Settings panel.
3. **Network Isolation**: Android container network traffic is governed by the central per-application network firewall.
