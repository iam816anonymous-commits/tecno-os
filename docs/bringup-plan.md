# IN6-Linux Project Phase Roadmap & Bring-Up Plan

## Phase Milestone Roadmap

```
+-------------------------------------------------------------+
|    MILESTONE 1: Research, Architecture & Build System       |
|    - Hardware Compatibility Matrix                          |
|    - MT6763 Mainline Analysis                               |
|    - Device Tree Skeleton & Build Tools (Completed)         |
+-------------------------------------------------------------+
                               |
                               v
+-------------------------------------------------------------+
|    MILESTONE 2: First Boot & Console Bring-Up (Phase 2)     |
|    - Tethered boot (`fastboot boot boot.img`)               |
|    - Earlycon UART0 / USB Serial Gadget (`/dev/ttyGS0`)     |
|    - Minimal BusyBox initramfs shell execution              |
+-------------------------------------------------------------+
                               |
                               v
+-------------------------------------------------------------+
|    MILESTONE 3: Core Peripherals Enablement                 |
|    - eMMC rootfs mounting (`/dev/mmcblk0p31`)               |
|    - DRM/KMS Display & MIPI DSI panel driver                |
|    - Touchscreen I2C bus identification & driver            |
+-------------------------------------------------------------+
                               |
                               v
+-------------------------------------------------------------+
|    MILESTONE 4: Native Linux Desktop / UI Bring-Up          |
|    - Panfrost OpenGL ES / Wayland Compositor                |
|    - ALSA / PipeWire MT6358 Audio stack                     |
|    - Wi-Fi & Bluetooth firmware integration                 |
+-------------------------------------------------------------+
```

---

## Detailed Action Plan for Phase 2 (Tethered First Boot)

1. **Extract Stock Panel Parameters**: Decompile stock DTB from `odmdtbo.img` to capture MIPI DSI display timings.
2. **Compile MT6763 Mainline Kernel**: Build Linux 6.1 LTS kernel with `mt6763-tecno-in6.dts`.
3. **Assemble Android Boot Image**: Combine kernel + minimal BusyBox initramfs into standard boot image using `mkbootimg`.
4. **Tethered Boot Test**: Execute non-destructive `fastboot boot build/artifacts/boot.img`.
5. **Console Log Capture**: Verify early boot logs via USB serial gadget (`/dev/ttyGS0`).
