# Hardware Inventory Directory

This directory contains verified device baseline properties captured from the stock TECNO IN6 / H633 running Android 8.1.0 with Linux kernel 4.4.95+.

## Files Overview
- `getprop.txt`: System properties dump (`ro.product.model`, `ro.board.platform`, etc.).
- `cpuinfo.txt`: Processor and CPU topology information from `/proc/cpuinfo`.
- `loaded-modules.txt`: Stock kernel module inventory (`lsmod`).
- `input-devices.txt`: Input event devices (`getevent -p`).
- `input-devices-proc.txt`: Input devices listed in `/proc/bus/input/devices`.
- `sensors.txt`: Hardware sensor subsystem properties.
- `display.txt`: Display panel and framebuffer properties.
- `camera.txt`: Camera sensor subsystem details.
- `battery.txt`: Power supply and PMIC properties.
- `partitions.txt`: Partition table and block device mappings.
- `mount.txt`: Stock mount table snapshot.
- `wireless.txt`: Wi-Fi, Bluetooth, and FM chip details.
- `audio.txt`: Audio subsystem and codec info.
- `device-tree-files.txt`: Stock device tree dump file listings.
- `uname.txt`: Kernel version and build timestamp info.
