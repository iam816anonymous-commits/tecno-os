# IN6-Linux Application Architecture & Runtime Specification

## Overview
IN6-Linux supports a tiered application architecture prioritized for native Linux execution while supporting containerized application runtimes.

---

## Application Priority Tiers

```
+-------------------------------------------------------------+
|    Tier 1: Native Linux Mobile Applications (GTK4 / Qt6)    |
|       (Runs natively on Wayland compositor over DRM/KMS)    |
+-------------------------------------------------------------+
|    Tier 2: Web Applications / PWAs (Chromium / WebKitGTK)   |
|       (Isolated inside containerized browser runtime)       |
+-------------------------------------------------------------+
|    Tier 3: Android Compatibility Subsystem (Waydroid)       |
|       (Optional containerized LXC subsystem layer)         |
+-------------------------------------------------------------+
```

---

## Technical Stack Selection

- **Display Protocol**: Native **Wayland** running over DRM/KMS (`/dev/dri/card0`).
- **Compositor**: **Wayfire** / **Weston** (lightweight C++ Wayland compositor with touch gesture support).
- **GUI Frameworks**: **GTK4** / **libadwaita** and **Qt6** / **Kirigami**.
- **Audio Server**: **PipeWire** with **WirePlumber** session manager.
