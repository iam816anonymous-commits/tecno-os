# Next Device Action Protocol

Current State: **READY_FOR_PHYSICAL_BOOT**

## Required Action
Execute non-destructive tethered boot on physical TECNO IN6 / H633 device:

```bash
fastboot boot build/artifacts/boot.img
```

Record and supply returned physical device execution telemetry to proceed to physical failure classification.
