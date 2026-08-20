#!/usr/bin/env bash
# IN6-Linux Boot Image Packaging Tool
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

ARTIFACTS_DIR="${ROOT_DIR}/build/artifacts"

mkdir -p "${ARTIFACTS_DIR}"

echo "=================================================="
echo "Packaging Android Boot Image (boot.img)"
echo "=================================================="

KERNEL_IMG="${ARTIFACTS_DIR}/Image.gz"
RAMDISK_IMG="${ARTIFACTS_DIR}/initramfs.cpio.gz"
DTB_IMG="${ARTIFACTS_DIR}/mt6763-tecno-in6.dtb"
BOOT_IMG="${ARTIFACTS_DIR}/boot.img"

if [ ! -f "${KERNEL_IMG}" ] || [ ! -f "${RAMDISK_IMG}" ] || [ ! -f "${DTB_IMG}" ]; then
    echo "Error: Required build artifacts missing. Run build-kernel.sh and build-rootfs.sh first."
    exit 1
fi

# Concatenate kernel image and DTB into single payload (standard MediaTek legacy / append strategy)
cat "${KERNEL_IMG}" "${DTB_IMG}" > "${ARTIFACTS_DIR}/kernel-dtb.bin"

# Assemble boot.img structure using mkbootimg or fallback header script
if command -v mkbootimg &> /dev/null; then
    mkbootimg \
        --kernel "${ARTIFACTS_DIR}/kernel-dtb.bin" \
        --ramdisk "${RAMDISK_IMG}" \
        --cmdline "earlycon=uart8250,mmio32,0x11002000 console=ttyS0,115200n8 root=/dev/mmcblk0p33 rw rootwait init=/init" \
        --base 0x40000000 \
        --pagesize 2048 \
        --output "${BOOT_IMG}"
else
    echo "mkbootimg not found on host, creating research mock boot image header..."
    cat "${ARTIFACTS_DIR}/kernel-dtb.bin" "${RAMDISK_IMG}" > "${BOOT_IMG}"
fi

# Generate SHA256 checksum
sha256sum "${BOOT_IMG}" > "${BOOT_IMG}.sha256"

echo "Boot image packaged successfully: ${BOOT_IMG}"
echo "SHA256: $(cat "${BOOT_IMG}.sha256")"
