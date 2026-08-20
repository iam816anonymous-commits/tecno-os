# Device Tree Definitions for TECNO IN6 / H633

This directory contains the source-controlled Device Tree definitions for the TECNO IN6 smartphone.

## Files Overview
- `mt6763-tecno-in6.dts`: Primary board Device Tree Source file.
- `mt6763-tecno-in6.dtsi`: Board Device Tree Include file containing peripheral nodes and memory layouts.

## DTS Compilation Command
To compile the device tree source to DTB format on host machine:
```bash
cpp -P -x assembler-with-cpp device/tecno/in6/dts/mt6763-tecno-in6.dts /tmp/mt6763-tecno-in6.pp.dts
dtc -I dts -O dtb -o build/artifacts/mt6763-tecno-in6.dtb /tmp/mt6763-tecno-in6.pp.dts
```
