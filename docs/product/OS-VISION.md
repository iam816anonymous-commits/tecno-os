# IN6-Linux Master OS Vision & Product Philosophy

## Executive Vision
**IN6-Linux** is an independent, privacy-first, offline-capable mobile operating system engineered specifically for the **TECNO IN6 / H633** (MediaTek MT6763 / Helio P23, 3GB RAM, 32GB eMMC).

> **THIS IS NOT A CUSTOM ROM.**
> IN6-Linux is NOT LineageOS, AOSP, GrapheneOS, /e/OS, or Ubuntu Touch. It does not run Android framework services, ART, Bionic libc, or Android HALs as its base operating system.

---

## Ten Master Principles

1. **User Ownership**: The user is the absolute owner of the device. System settings and hardware toggles are absolute.
2. **Privacy First**: Zero telemetry, zero analytics, zero crash reporting, zero advertising IDs by default.
3. **Offline First**: Complete operational utility without Internet access. Core apps (Terminal, Files, Camera, Settings, Contacts, Notes, Clock) require no network.
4. **No Cloud Dependency**: No mandatory accounts, online activation, or proprietary cloud APIs.
5. **Explicit Permission Enforcement**: Granular per-application capability enforcement (ALLOW, DENY, ASK, ONE-TIME, WHILE-IN-USE) implemented below the application layer.
6. **Per-App Network Control**: Independent per-application firewall isolation (Allow, Deny, Wi-Fi only, Cellular only, Local network only).
7. **Hardware Transparency**: Real-time status reporting for all peripherals (Microphone, Camera, GPS, Sensors, USB, Network).
8. **Native Linux Architecture**: Standard Linux APIs (Wayland, DRM/KMS, ALSA, PipeWire, NetworkManager, udev, musl/glibc).
9. **Reproducible & Verifiable**: Sealed containerized build pipeline generating SHA256-checksummed boot and system images.
10. **Pragmatic Hardware Bring-Up**: Progressive kernel migration (Stock 4.4.95 baseline -> Modern LTS Mainline) without sacrificing working hardware support.
