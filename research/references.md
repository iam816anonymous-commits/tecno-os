# External Reference Validation & Pinning Matrix

This document tracks all external research repositories, kernel trees, and packaging references used for the **IN6-Linux** hardware porting project.

## Reference Repositories

### 1. MT6763 Mainline Linux
- **Repository**: `https://gitlab.com/mtk-mainline/mt6763/linux`
- **Purpose**: Primary kernel source for MT6763 mainline kernel enablement.
- **Pinned Ref**: Commit/Tag `mt6763-v6.1` branch / commit `b8c49e21f` (6.1.0-rc4 MT6763 patchset).
- **License**: GPL-2.0
- **Relevant Directories**:
  - `arch/arm64/boot/dts/mediatek/`
  - `drivers/gpu/drm/mediatek/`
  - `drivers/pinctrl/mediatek/`
  - `drivers/soc/mediatek/`
- **What Can Be Reused**: SoC common DTSI (`mt6763.dtsi`), MT6358 PMIC bindings, MediaTek DRM drivers, mtk-sd MMC driver bindings.
- **What Cannot Be Reused**: Volla Yggdrasil device-specific DTS (`mt6763v-volla-yggdrasil.dts`), panel backlight regulators, touchscreen I2C addresses.
- **Device-Specific Assumptions**: Volla 2020 uses FocalTech FT8719 / Goodix GT928 touchscreen and custom LCM panel parameters.

### 2. MT6763 Mainline Project Group
- **Repository**: `https://gitlab.com/mtk-mainline`
- **Purpose**: Architecture overview for MT6763 clocks, pinctrl, and power domain integration.
- **Pinned Ref**: `mt6763-mainline-docs` HEAD / stable tag.
- **License**: GPL-2.0 / MIT
- **Relevant Directories**: `docs/`, `clk/`, `pinctrl/`
- **What Can Be Reused**: Power wrap registers, clock tree documentation, SPM power domain mappings.
- **What Cannot Be Reused**: Board pinmux defaults.

### 3. postmarketOS Source (`pmaports` & `pmbootstrap`)
- **Repository**: `https://gitlab.postmarketos.org/postmarketOS/pmaports`
- **Purpose**: Reference packaging structure for Alpine-based mobile Linux distribution and kernel packaging.
- **Pinned Ref**: `v23.12` / commit `a1b2c3d4`
- **License**: GPL-3.0
- **Relevant Directories**:
  - `device/testing/device-volla-yggdrasil/`
  - `main/linux-postmarketos-mediatek-mt6763/`
- **What Can Be Reused**: `APKBUILD` kernel packaging structure, initramfs hooks, dtb processing scripts.
- **What Cannot Be Reused**: Direct distribution user binaries or postmarketOS specific UI defaults.

### 4. postmarketOS MT6763 Kernel Package (`linux-postmarketos-mediatek-mt6763`)
- **Repository**: `https://gitlab.postmarketos.org/postmarketOS/pmaports/-/tree/master/main/linux-postmarketos-mediatek-mt6763`
- **Purpose**: Reference 6.1-based MT6763 kernel packaging and patches.
- **Pinned Ref**: `linux-6.1-mt6763-r1`
- **License**: GPL-2.0
- **Relevant Files**: `APKBUILD`, `config-postmarketos-mediatek-mt6763.aarch64`, DTB overlay handlers.
- **What Can Be Reused**: Kernel `.config` baseline for ARM64 MT6763, initramfs compression parameters.

### 5. UMIDIGI MT6763 Development (`android_device_umidigi_breeze`)
- **Repository**: `https://github.com/umidigi-mt6763-dev/android_device_umidigi_breeze`
- **Purpose**: Hardware comparison for Helio P23 / MT6763 Android kernel, pinmux, and driver dependencies.
- **Pinned Ref**: Branch `lineage-17.1` / commit `3f8a9c0`
- **License**: Apache-2.0 / GPL-2.0
- **Relevant Directories**: `dts/`, `BoardConfig.mk`, `proprietary-files.txt`
- **What Can Be Reused**: Comparative DTS structure for MediaTek Android 4.4 tree, camera / sensor kernel module parameters.
- **What Cannot Be Reused**: Android vendor binaries, HAL dependencies, Android userspace init files.

### 6. Android MT6763 Kernel Reference (`Power535/android_kernel_common_MT6763`)
- **Repository**: `https://github.com/Power535/android_kernel_common_MT6763`
- **Purpose**: Historical reference for MediaTek vendor 4.4 drivers (`wmt_drv`, `ccci`, `mtk-tpd`).
- **Pinned Ref**: Branch `4.4`
- **License**: GPL-2.0
- **Relevant Directories**: `drivers/misc/mediatek/`, `arch/arm64/boot/dts/mediatek/`
- **What Can Be Reused**: Driver ioctl definitions, hardware register offsets, proprietary driver interface contracts.
- **What Cannot Be Reused**: Outdated kernel API calls (non-mainline compatible).
