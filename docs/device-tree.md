# IN6 Device Tree Architecture & Management Strategy

## Overview
Device trees (`.dts` / `.dtsi`) serve as the hardware abstraction layer for the Linux kernel on ARM64 platforms. This document outlines the device tree hierarchy for the **TECNO IN6 / H633**.

---

## Device Tree Hierarchy

```
kernel/arch/arm64/boot/dts/mediatek/
├── mt6763.dtsi                   <-- Common MT6763 SoC definitions (CPU, GIC, Bus, Clocks)
├── mt6358.dtsi                   <-- PMIC regulator & codec definitions
└── device/tecno/in6/dts/
    ├── mt6763-tecno-in6.dtsi      <-- IN6 Board-level common buses (I2C, SPI, Pinctrl)
    └── mt6763-tecno-in6.dts       <-- Final device DT (Memory, chosen bootargs, panel)
```

---

## Key Board DT Nodes (`mt6763-tecno-in6.dts`)

### 1. Memory Configuration
```dts
memory@40000000 {
    device_type = "memory";
    reg = <0x0 0x40000000 0x0 0xC0000000>; /* 3GB LPDDR RAM */
};
```

### 2. Chosen Node & Earlycon
```dts
chosen {
    bootargs = "earlycon=uart8250,mmio32,0x11002000 console=ttyS0,115200n8 root=/dev/mmcblk0p33 rw rootwait init=/init";
};
```

### 3. Strict Placeholder Directives
Where hardware properties are unverified from device telemetry:
- Flag as `TODO_UNKNOWN`
- Flag as `REQUIRES_IN6_MEASUREMENT`

Do NOT guess I2C slave addresses, pinmux numbers, or regulator voltage limits.
