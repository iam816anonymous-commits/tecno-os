# IN6-Linux Kernel Strategy & Evolutionary Roadmap

## Objective
Establish a structured kernel migration strategy for the **TECNO IN6 / H633** moving from legacy Android vendor code to a modern, upstreamed Linux kernel.

---

## Evaluation of Kernel Approaches

| Criteria | Approach A: Stock 4.4.95 Kernel | Approach B: MT6763 Mainline Kernel (6.1 LTS) | Approach C: Hybrid Transition |
|---|---|---|---|
| **Feasibility** | Immediate boot on stock ROM environment. | High (Proven on Volla Phone 2020). | High (Phased bring-up). |
| **Driver Availability** | Complete stock drivers (Proprietary MTK). | Mainline drivers (`mtk-sd`, Panfrost, MT6358). | Stock drivers used as reference. |
| **Device Tree Effort** | Low (Uses vendor DTB). | High (Requires IN6 custom DTS creation). | Progressive DTB refinement. |
| **Graphics (DRM)** | Legacy FB / MTK DISP wrapper. | Modern DRM/KMS + Panfrost Mali driver. | Panfrost enabled on Mainline. |
| **Security & Viability** | EOL (Kernel 4.4 end-of-life). | Maintained (Linux 6.1 LTS LTS patches). | Strategic security alignment. |
| **Android Dependency** | Heavy (Tied to Android Bionic/HALs). | Zero (Pure Linux kernel interfaces). | Decoupled userspace. |

---

## Recommended Strategy: Phased Hybrid Migration

### Phase 1: Hardware-Reference Kernel (Stock 4.4.95)
- **Purpose**: Decompile stock DTBs, extract register maps, pinmux layouts, panel parameters, and ioctl definitions.
- **Action**: Do NOT use stock kernel for final OS build. Use purely for telemetry extraction.

### Phase 2: Initial Mainline Bring-Up (MT6763 6.1 LTS Kernel)
- **Purpose**: Boot Linux 6.1 kernel with custom `mt6763-tecno-in6.dts`.
- **Target**: Successful boot to serial/USB console (`/dev/ttyGS0`), eMMC initialization, and basic rootfs execution.

### Phase 3: Hardware Drivers Bring-Up
- **Purpose**: Progressive enablement of display (DRM DSI), touchscreen, USB OTG, ALSA audio, and Wi-Fi firmware loading.
- **Target**: Functional GUI compositor (Wayland) + touchscreen event processing.

### Phase 4: Modern Upstream Kernel Transition
- **Purpose**: Track latest upstream Linux kernels (`git.kernel.org`) as MT6763 patches land in mainline.
