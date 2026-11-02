# TECNO IN6 GPUProbe APK Validation — 2026-11-02

## Scope and evidence

This note records three GPUProbe reports exported directly from the user's TECNO IN6 (H633), plus the earlier APK OpenCL loading result. It is a hardware observation record, not a claim that a neural-network inference runtime is supported.

Capture times (India Standard Time):
- Full workload report: 17:10:02
- Standalone 1,024-element Vulkan report: 17:10:21
- Device snapshot and OpenCL report: 17:10:35

Device identity was consistent across reports:
- TECNO IN6 / product H633 / hardware MT6763V/V
- Android 8.1.0 / API 27
- Build fingerprint: TECNO/H633/TECNO-IN6:8.1.0/O11019/A-201023V208:user/release-keys
- Kernel 4.4.95+
- ABIs: arm64-v8a, armeabi-v7a, armeabi
- GPU: Mali-G71, vendor 0x13b5, device 0x60a00002
- Vulkan API: 1.0.58

## Automatic device snapshot

| Field | Observation |
|---|---:|
| Total RAM | 3,824 MB |
| Available RAM across captures | 2,376–2,414 MB |
| Display | 720 × 1440 |
| Density | 320 dpi |
| Refresh rate | 60.43 Hz |
| Data partition total | 54,325 MB |
| Data partition available | 45,313 MB |
| Battery | 100% |
| Battery temperature | 34.0°C |
| Sensors listed | KXTJ2_1009 accelerometer; LTR579 light; LTR579 proximity |

Battery temperature is not GPU temperature. The report states it uses public Android APIs and readable procfs entries and excludes serial number, Android ID, contacts, files and location.

## Vulkan workload sweep from the APK

| Elements | Repetitions | Dispatch + queue-wait wall time | Incorrect outputs | Result |
|---:|---:|---:|---:|---|
| 1,024 | 10 | 12.5835 ms | 0 | PASS |
| 16,384 | 8 | 3.34585 ms | 0 | PASS |
| 65,536 | 5 | 2.51469 ms | 0 | PASS |
| 262,144 | 3 | 3.27631 ms | 0 | PASS |
| 1,048,576 | 1 | 4.54692 ms | 0 | PASS |

A separate 1,024-element test captured at 17:10:21 reported 10 repetitions and 1.95638 ms. These two timings differ substantially, so timing must be treated as variable and not summarized as a single stable number.

Each workload reported Mali-G71, Vulkan 1.0.58, selected compute queue, created compute pipeline, JNI PASS and zero incorrect outputs. The largest workload was 1,048,576 float elements.

These are dispatch-plus-queue-wait wall times. They are not isolated GPU execution times. The CPU reference is not a matched benchmark: implementation and repetition counts differ.

## Vulkan properties reported by the APK

| Property | Value |
|---|---:|
| Maximum compute workgroup invocations | 384 |
| Maximum workgroup size X | 384 |
| Maximum workgroup count X | 65,536 |
| Maximum storage buffer range | 256 MiB |
| Memory heaps | 1 |
| Memory types | 3 |
| Heap 0 reported size | 2,048 MiB |
| Heap 0 flags | 0x1 |

The reported heap size is not proof of dedicated VRAM or guaranteed app-allocatable memory.

## OpenCL APK result

The APK reported:

`dlopen("libOpenCL.so")` failed because the library was not found in the app linker namespace; JNI RESULT: FAIL.

Earlier shell-level testing successfully loaded the vendor OpenCL runtime and executed a vector-add kernel. Therefore:
- OpenCL shell compute: confirmed.
- Normal OpenCL loading from this APK: failed.
- No linker namespace bypass, root access or security weakening was attempted.

## Source-level benchmark caveat

The uploaded GPUProbe source was found to record a command buffer with `VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT` and then submit that same command buffer repeatedly. The observed outputs are PASS, but repeated reuse conflicts with the one-time-submit contract. Repeated-dispatch timing and stability should remain provisional until the command buffer is made reusable or reset/re-recorded for each submission and the tests are rerun.

## Conclusions

Confirmed:
- Vulkan compute works inside an ordinary Android API 27 APK on this Mali-G71.
- The APK completed the reported vector-add workloads up to 1,048,576 elements with zero reported incorrect outputs.
- The APK can query useful Vulkan workgroup and memory properties.
- The device snapshot can be collected and exported directly from the phone.

Not established:
- Dedicated GPU VRAM or a process GPU memory budget.
- GPU utilization, GPU clock under load, or GPU temperature.
- Sustained throughput, thermal throttling or long-run stability.
- Normal APK OpenCL access.
- Neural-network inference runtime compatibility, operator coverage, quantization support or AI inference performance.

## Next validation

1. Fix the command-buffer lifecycle and rerun the workload sweep.
2. Separate host recording, data transfer, dispatch, synchronization and readback timings.
3. Run longer controlled stability tests and collect supported telemetry.
4. Investigate only documented Android-supported OpenCL integration paths.
5. Evaluate a small neural-network model using a compatible runtime, verifying correctness, memory use and latency.
