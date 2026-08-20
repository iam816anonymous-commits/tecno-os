# IN6-Linux Reference Projects Architectural Research

This document analyzes ten major mobile, embedded, and privacy-focused operating system projects as architectural reference sources for the **IN6-Linux** project targeting the **TECNO IN6 / H633** (MediaTek MT6763 / Helio P23 SoC).

---

## 1. postmarketOS
- **Repository**: `https://gitlab.postmarketos.org/postmarketOS`
- **License**: GPL-3.0-or-later
- **Architecture**: Alpine Linux derivative, musl libc, OpenRC/s6, APK package manager, mainline-first kernel strategy.
- **Relevant Components**: `pmbootstrap` build tooling, `device-` and `linux-` packaging schemas, APKBUILD recipes for MT6763 (`linux-postmarketos-mediatek-mt6763`).
- **Lessons for IN6-Linux**: Outstanding reference for packaging source-controlled device trees, containerized cross-compilation toolchains, and handling downstream vendor kernel patches vs mainline transitions.
- **What Cannot Be Reused**: Alpine packaging binaries directly; postmarketOS userland defaults without permission brokers.
- **Hardware Relevance**: **HIGH**. Contains active MT6763 kernel and DTB sources (`mt6763v-volla-yggdrasil.dtb`).

---

## 2. Mobian
- **Repository**: `https://gitlab.com/mobian1`
- **License**: GPL-3.0 / MIT
- **Architecture**: Debian ARM64 derivative, glibc, systemd, Phosh / GTK4 / Wayland compositor stack.
- **Relevant Components**: Phosh mobile shell integration, NetworkManager configuration profiles, PipeWire audio routing, ModemManager call/SMS integration.
- **Lessons for IN6-Linux**: Demonstrates how standard desktop Linux packages (Debian) can be adapted for touch mobile form factors using GTK4 / Wayland.
- **What Cannot Be Reused**: Heavy systemd dependencies if a lightweight init (s6/runit/musl) is chosen; heavy idle RAM footprint for 3GB IN6 hardware.
- **Hardware Relevance**: **MEDIUM**. Software UI stack reference for Linux mobile shells.

---

## 3. Plasma Mobile
- **Repository**: `https://invent.kde.org/plasma/plasma-mobile`
- **License**: GPL-2.0 / LGPL-2.1 / BSD
- **Architecture**: KDE / Qt6 / KWin Wayland compositor stack on top of standard Linux distributions.
- **Relevant Components**: Touch-friendly mobile shell components, KWayland protocols, Plasma Settings, mobile control center widgets.
- **Lessons for IN6-Linux**: Reference for touch-optimized Qt6 widgets and modular panel UI.
- **What Cannot Be Reused**: High memory footprint when fully loaded; requires hardware-accelerated OpenGL ES 3.0 via Mali-G71 / Panfrost.
- **Hardware Relevance**: **MEDIUM**. UI/UX reference for touch controls and system status toggles.

---

## 4. Ubuntu Touch / UBports
- **Repository**: `https://gitlab.com/ubports`
- **License**: GPL-3.0 / LGPL-3.0
- **Architecture**: Ubuntu ARM64 base, Lomiri (formerly Unity8) Qt-based mobile shell, Halium / libhybris hardware abstraction layer over Android LXC containers.
- **Relevant Components**: Lomiri UI, AppArmor security profiles, Click/Clickable package isolation, Halium containerization structure.
- **Lessons for IN6-Linux**: Excellent AppArmor security profile examples for mobile application sandboxing and permission brokers.
- **What Cannot Be Reused**: Heavy dependence on Android LXC container abstractions (Halium) as the core OS foundation.
- **Hardware Relevance**: **HIGH**. Reference for AppArmor sandbox policies and mobile application permissions.

---

## 5. PureOS / Librem
- **Repository**: `https://repo.pureos.net/`
- **License**: FSF Free Software Guidelines (GPL / LGPL)
- **Architecture**: Pure Debian derivative (100% free software), Phosh / Squeekboard, Calls, Chats (Purism mobile suite).
- **Relevant Components**: Calls (modem call interface), Chats (SMS/MMS client), hardware kill switch UX paradigms, strict anti-telemetry policies.
- **Lessons for IN6-Linux**: Gold standard for offline-first, zero-telemetry, user-owned mobile OS philosophy and hardware privacy kill switch handling.
- **What Cannot Be Reused**: PureOS hardware drivers are x86/NXP i.MX8M specific and lack MediaTek vendor support.
- **Hardware Relevance**: **HIGH**. Core philosophy and application UI suite reference.

---

## 6. Tizen
- **Repository**: `https://review.tizen.org/gerrit/`
- **License**: EFL / GPL-2.0 / BSD
- **Architecture**: Linux kernel, EFL (Enlightenment Foundation Libraries), CAPI native services, Security Manager / Smack MAC framework.
- **Relevant Components**: Lightweight EFL UI framework, Smack security domain isolation, power-efficient mobile service architecture.
- **Lessons for IN6-Linux**: Demonstrates ultra-low RAM footprint UI rendering and fine-grained Smack access control for low-spec ARM hardware.
- **What Cannot Be Reused**: Tizen proprietary Samsung platform drivers; complex build infrastructure.
- **Hardware Relevance**: **LOW**. Architecture reference for low-memory footprint optimization.

---

## 7. Sailfish OS
- **Repository**: `https://github.com/sailfishos`
- **License**: Proprietary UI / GPL-2.0 Core (Mer / Nemo Mobile)
- **Architecture**: Linux kernel, RPM package management, systemd, Lipstick Qt/QML Wayland compositor, libhybris Android driver wrapper.
- **Relevant Components**: Lipstick Wayland compositor architecture, QML mobile components, libhybris audio/camera integration.
- **Lessons for IN6-Linux**: Qt/QML gesture-based navigation patterns and efficient Wayland compositor execution on embedded ARM GPUs.
- **What Cannot Be Reused**: Proprietary Sailfish OS gesture UI and closed-source components.
- **Hardware Relevance**: **MEDIUM**. Wayland compositor gesture architecture reference.

---

## 8. Replicant
- **Repository**: `https://git.replicant.us/`
- **License**: GPL-2.0 / Apache-2.0
- **Architecture**: 100% Free Software Android distribution (AOSP fork without proprietary blobs).
- **Relevant Components**: Free-software replacement drivers for IPC/modem (Samsung IPC), reverse-engineering methodology for mobile peripherals.
- **Lessons for IN6-Linux**: Reverse-engineering strategies for mobile modems, audio codecs, and Wi-Fi drivers without proprietary blobs.
- **What Cannot Be Reused**: Android userspace architecture (Bionic, HALs, ART).
- **Hardware Relevance**: **LOW**. Reverse-engineering methodology reference.

---

## 9. GrapheneOS
- **Repository**: `https://github.com/GrapheneOS`
- **License**: MIT / Apache-2.0 / GPL-2.0
- **Architecture**: Hardened AOSP derivative, hardened memory allocator (hardened_malloc), per-app network/sensor permissions, secure boot enforcement.
- **Relevant Components**: Per-application network permission toggles, per-application sensor permission toggles, hardened memory allocator, strict sandboxing models.
- **Lessons for IN6-Linux**: Unmatched reference for granular per-application network and sensor permission enforcement policies.
- **What Cannot Be Reused**: AOSP framework code and Android-specific Java permission controllers.
- **Hardware Relevance**: **HIGH**. Security, sandboxing, and network permission policy reference.

---

## 10. /e/OS (eFoundation)
- **Repository**: `https://gitlab.e.foundation/e`
- **License**: GPL-3.0 / Apache-2.0
- **Architecture**: DeGoogled AOSP / LineageOS fork, MicroG integration, Advanced Privacy Dashboard.
- **Relevant Components**: Advanced Privacy Dashboard UI (tracking real-time tracker blocks, location spoofing, and IP hiding).
- **Lessons for IN6-Linux**: Clear UX paradigms for displaying hardware permission usage, blocked telemetry attempts, and privacy statistics to the user.
- **What Cannot Be Reused**: Android LineageOS codebase and MicroG dependencies.
- **Hardware Relevance**: **MEDIUM**. Privacy Dashboard UX reference.
