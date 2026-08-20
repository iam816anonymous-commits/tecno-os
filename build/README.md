# IN6-Linux Build & Tooling Directory

This directory contains the reproducible build system and verification scripts for the IN6-Linux operating system.

## Scripts Overview
- `configure.sh`: Toolchain dependency detection and build environment export.
- `build-kernel.sh`: Device Tree preprocessing and DTC compilation.
- `build-rootfs.sh`: Skeleton initramfs root filesystem generation.
- `build-image.sh`: Android `boot.img` packaging and SHA256 checksum generation.
- `clean.sh`: Cleans build output directories.
- `verify.sh`: Automated host validation script enforcing DTS compilation and non-flashing guardrails.
- `build.ps1`: Windows PowerShell wrapper triggering WSL build pipeline.
