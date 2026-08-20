# IN6-Linux Component Licensing Audit & Legal Compliance

## Overview
This document tracks the open-source license obligations for every external reference project, kernel source tree, build tool, and userspace component used in **IN6-Linux**.

---

## Component License Tracking Table

| Component / Reference | Source Project / Repository | License Type | Compliance Directive |
|---|---|---|---|
| **Linux Kernel / Drivers** | Transsion / MT6763 Kernel Tree (`Power535`) | GPL-2.0-only | Source modifications in `kernel/` remain GPL-2.0 |
| **Device Tree Source (DTS)** | Upstream Linux / IN6-Linux Project | GPL-2.0-only / BSD-2-Clause | Source header contains dual GPL-2.0 / BSD license notice |
| **Device Tree Compiler (DTC)**| Upstream `dtc` Toolchain | GPL-2.0-or-later / BSD-2-Clause | Host build utility |
| **Initramfs / BusyBox** | BusyBox / Alpine Init Utilities | GPL-2.0-only | Minimal C utilities in initramfs |
| **postmarketOS Reference** | postmarketOS (`pmaports`) | GPL-3.0-or-later | Reference packaging scripts and DTB recipes |
| **Mobian / Debian Reference** | Mobian / Debian Mobile Project | GPL-3.0 / MIT | Packaging and Phosh reference architecture |
| **Wayland / Wayfire Compositor**| Wayland / Wayfire Compositor Stack | MIT / LGPL-2.1 | Lightweight Wayland compositor stack |
| **PipeWire Audio Server** | PipeWire Project | MIT | Audio routing and session management daemon |
| **AppArmor LSM** | Linux Kernel LSM / Canonical | GPL-2.0-only / LGPL-2.1 | Mandatory Access Control profiles |
