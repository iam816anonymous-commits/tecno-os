# IN6-Linux Offline-First Architecture & Local Package Management

## Overview
**IN6-Linux** is an offline-first operating system. Complete system configuration, application installation, diagnostics, and recovery must function seamlessly without Internet connectivity.

---

## Offline Core Capabilities

1. **Local Package Installation**: Packages (`.apk` / `.tar.xz` bundles) can be installed offline from local storage or SD card.
2. **Offline System Utilities**:
   - Terminal Shell & Diagnostic Tools (`dmesg`, `lsmod`, `i2cdetect`)
   - File Manager (`/home/user/`, SD card)
   - Settings & Hardware Permissions Dashboard
   - Clock, Alarms, Stopwatches
   - Contacts & Offline SQLite Database
   - Camera & Offline Image Viewer
   - Media Player & Offline Audio Playback
3. **Zero Network Booting**: System boots cleanly to UI with Wi-Fi, Bluetooth, and Cellular Data completely disabled.
