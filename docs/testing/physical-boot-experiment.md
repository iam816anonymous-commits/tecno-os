# Physical Boot Experiment Protocol: TECNO IN6 / H633

## Objective
Tethered non-destructive execution test of the candidate IN6-Linux boot image on physical TECNO IN6 target hardware.

## Frozen Artifact Baseline
- **boot.img SHA256**: `1be088f9d7d56529e791ad16994f3eb5f3e171e5b2616e74f5fc315c5b5d151c`
- **Image.gz SHA256**: `933f950114057691460af994f28ad7e17e192daaf30dc358887bfaedef817c67`
- **DTB SHA256**: `cb25ad89f51f8a365ee6c854c76177e29040fbebf6046e584b3e0932c4a9af6e`
- **initramfs SHA256**: `3ad06e0cdd9855d61e89e4b716744e30d6f4981e27015ee7d5abdb5c482934ab`
- **Page Size**: 2048
- **Kernel Load Address**: `0x40008000`
- **Ramdisk Load Address**: `0x44000000`
- **Tags Address**: `0x40000100`
- **Cmdline**: `earlycon=uart8250,mmio32,0x11002000 console=ttyS0,115200n8 root=/dev/mmcblk0p33 rw rootwait init=/init`

## Safety & Non-Destructive Policy
**CRITICAL MANDATE**:
- Do **NOT** use `fastboot flash`.
- Do **NOT** use `fastboot erase`.
- Do **NOT** use `fastboot format`.
- Do **NOT** perform raw block writes to `/dev/block/`.

## Device Verification Commands
```bash
fastboot devices
fastboot getvar product
fastboot getvar unlocked
fastboot getvar secure
```

Expected Target: `product: IN6_H633`, `unlocked: yes`, `secure: no`.

## Tethered Boot Command
Run the non-destructive tethered boot command from the host repository root:

```bash
fastboot boot build/artifacts/boot.img
```

## Telemetry Capture Protocol
1. **LK Bootloader Output**:
   Observe screen state and USB serial console if UART adapter / CDC ACM is connected.
2. **Kernel Telemetry**:
   If earlycon/UART is attached, record kernel log stream starting at `0.000000`.
3. **Initramfs / USB ADB**:
   If kernel boots and initializes USB gadget, check `adb devices` or `dmesg` via host.

## Failure Classification
- **F0**: Host/USB/fastboot connection problem
- **F1**: Bootloader rejected image
- **F2**: Boot image parsing/loading failure
- **F3**: Kernel entry failure
- **F4**: Early ARM64/kernel initialization failure
- **F5**: DTB/FDT failure
- **F6**: Initramfs/init failure
- **F7**: USB/ADB failure
