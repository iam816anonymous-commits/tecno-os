# IN6-Linux Centralized Permission Broker Specification

## Overview
Permissions in **IN6-Linux** are enforced by a system-level IPC permission broker that mediates access between applications and underlying hardware services.

---

## Permission States

Every capability grant supports five distinct policy evaluation states:
1. **ALLOW**: Permanently granted until explicitly revoked by the user.
2. **DENY**: Permanently blocked; application receives empty/dummy device responses.
3. **ASK**: User is prompted via a modal dialog whenever access is requested.
4. **ONE-TIME**: Access is granted for a single operation/session and automatically expires.
5. **WHILE-IN-USE**: Access is granted only while the application window is focused in the foreground.

---

## 16 Capability Domains

| Domain | Controlled Resource / Hardware | Enforcement Layer |
|---|---|---|
| **Camera** | `/dev/video*`, V4L2 Subdev | cgroup device whitelist + Permission Broker |
| **Microphone** | PipeWire Audio Input Stream | PipeWire client node ACL |
| **Location** | GPS / GNSS UART (`/dev/ttyS1`) | Geolocation daemon IPC token |
| **Contacts** | Address Book SQLite DB | SQLite VFS permission filter |
| **SMS** | Telephony Daemon (`ModemManager`) | D-Bus policy enforcement |
| **Phone / Calls** | Telephony Voice Channel | D-Bus policy enforcement |
| **Filesystem** | Storage Directories (`/home/user/`) | AppArmor mount profile |
| **USB** | USB OTG Host Devices | udev ACL + cgroup device controller |
| **Bluetooth** | BlueZ DBus API | BlueZ agent permission check |
| **Wi-Fi** | NetworkManager DBus API | Polkit action restrictions |
| **Sensors** | IIO Sensor Nodes (`/sys/bus/iio`) | iio-sensor-proxy IPC filter |
| **Background Exec** | CPU / RAM Background execution | cgroups v2 freezer controller |
| **Notifications** | Notification Daemon | D-Bus notification broker filter |
| **Clipboard** | Wayland Clipboard Selection | Wayland compositor data offer filter |
| **Network** | Network Socket Creation | iptables cgroup socket filter |
| **Cellular Data** | Packet Data Protocol (PDP) Context | ModemManager bearer control |
