# IN6-Linux UART & Early Boot Serial Observability Specification

## Overview
This document specifies the early serial console configuration and physical debug options for the **TECNO IN6 / H633** (MediaTek MT6763).

---

## 1. MediaTek MT6763 UART Architecture

The MediaTek MT6763 SoC includes four 8250-compatible UART IP cores:
- **UART0** (`0x11002000`): Primary Application Processor (AP) debug serial console.
- **UART1** (`0x11003000`): Bluetooth HCI serial interface (MT6631 combo chip).
- **UART2** (`0x11004000`): Auxiliary serial interface.
- **UART3** (`0x11005000`): Modem / CCCI debug interface.

---

## 2. Early Console Kernel Parameters

To enable early serial output from the Linux kernel before pinctrl/TTY subsystem drivers are initialized, the candidate `boot.img` command line uses:

```
earlycon=uart8250,mmio32,0x11002000 console=ttyS0,115200n8
```

### Parameter Breakdown:
- `earlycon=uart8250,mmio32,0x11002000`: Direct MMIO 32-bit register write access to UART0 at `0x11002000`.
- `console=ttyS0,115200n8`: Standard 8250 TTY driver serial console at 115,200 baud, 8 data bits, no parity.

---

## 3. Physical UART Access & Test Pads

- **Physical Test Pad Mapping**: `UNKNOWN — REQUIRES IN6 MEASUREMENT`
- **USB Serial Gadget Handoff (`/dev/ttyGS0`)**:
  When physical UART test pads (`TX`/`RX`/`GND`) are unpopulated or unmeasured on the phone motherboard, early boot diagnostic logs are captured over the USB CDC ACM serial gadget interface (`/dev/ttyGS0`).
