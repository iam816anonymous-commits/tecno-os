# Physical Boot Experiment Protocol: TECNO IN6 / H633

## Objective
Tethered non-destructive execution test of the candidate IN6-Linux boot image on physical TECNO IN6 target hardware.

## Safety & Non-Destructive Policy
**CRITICAL MANDATE**:
- Do **NOT** use `fastboot flash`.
- Do **NOT** use `fastboot erase`.
- Do **NOT** use `fastboot format`.
- Do **NOT** perform raw block writes to `/dev/block/`.

## Prerequisites
1. Target Device: **TECNO IN6 (Model H633)**.
2. Bootloader State: **Unlocked** (`unlocked: yes`).
3. USB Connection: Host connected via Micro-USB data cable.
4. Target Mode: `fastboot` mode (`adb reboot bootloader` or Vol Down + Power on boot).

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

## Success & Failure Classification
- **Level 0 (Bootloader Parse Error)**: Device hangs at LK or rejects boot header.
- **Level 1 (Kernel Entry Crash)**: Screen stays black, kernel panics before console init.
- **Level 2 (Early Console Output)**: Kernel prints early log output.
- **Level 3 (Initramfs Executed)**: `/init` script executes milestone log messages.
- **Level 4 (USB/ADB Available)**: Diagnostic shell reachable over USB.
