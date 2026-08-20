#!/usr/bin/env bash
# IN6-Linux Candidate Boot Image Packaging Pipeline
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

ARTIFACTS_DIR="${ROOT_DIR}/build/artifacts"
BOOT_IMG="${ARTIFACTS_DIR}/boot.img"

mkdir -p "${ARTIFACTS_DIR}"

echo "=================================================="
echo "Packaging Candidate Boot Image (boot.img)"
echo "=================================================="

KERNEL_IMG="${ARTIFACTS_DIR}/Image.gz"
RAMDISK_IMG="${ARTIFACTS_DIR}/initramfs.cpio.gz"
DTB_IMG="${ARTIFACTS_DIR}/mt6763-tecno-in6.dtb"

if [ ! -f "${KERNEL_IMG}" ] || [ ! -f "${RAMDISK_IMG}" ] || [ ! -f "${DTB_IMG}" ]; then
    echo "Error: Required build artifacts missing. Executing prerequisites..."
    bash "${SCRIPT_DIR}/build-kernel.sh"
    bash "${SCRIPT_DIR}/build-rootfs.sh"
fi

# Concatenate kernel image and DTB into single payload (standard MediaTek legacy / append strategy)
cat "${KERNEL_IMG}" "${DTB_IMG}" > "${ARTIFACTS_DIR}/kernel-dtb.bin"

# Assemble Android Header v0 boot.img format using Python struct packager or mkbootimg
if command -v mkbootimg &> /dev/null; then
    mkbootimg \
        --kernel "${ARTIFACTS_DIR}/kernel-dtb.bin" \
        --ramdisk "${RAMDISK_IMG}" \
        --cmdline "earlycon=uart8250,mmio32,0x11002000 console=ttyS0,115200n8 root=/dev/mmcblk0p33 rw rootwait init=/init" \
        --base 0x40000000 \
        --pagesize 2048 \
        --output "${BOOT_IMG}"
else
    # Pack valid Android Header v0 binary structure in python
    python3 -c '
import struct, os
kernel_path = "'"${ARTIFACTS_DIR}/kernel-dtb.bin"'"
ramdisk_path = "'"${RAMDISK_IMG}"'"
boot_path = "'"${BOOT_IMG}"'"

k_bytes = open(kernel_path, "rb").read()
r_bytes = open(ramdisk_path, "rb").read()

magic = b"ANDROID!"
k_size = len(k_bytes)
k_addr = 0x40008000
r_size = len(r_bytes)
r_addr = 0x44000000
second_size = 0
second_addr = 0x40f00000
tags_addr = 0x40000100
page_size = 2048
header_version = 0
os_version = 0
cmdline = b"earlycon=uart8250,mmio32,0x11002000 console=ttyS0,115200n8 root=/dev/mmcblk0p33 rw rootwait init=/init"

# Android Header v0 structure:
# offset 0-48: magic, sizes, addresses, page_size, header_version, os_version
# offset 48-64: name (16 bytes)
# offset 64-576: cmdline (512 bytes)
# offset 576-608: id (32 bytes)
# offset 608-1632: extra_cmdline (1024 bytes)
hdr = struct.pack("<8sIIIIIIIIII", magic, k_size, k_addr, r_size, r_addr, second_size, second_addr, tags_addr, page_size, header_version, os_version)
hdr += b"\x00" * 16                 # name (16 bytes)
hdr += cmdline.ljust(512, b"\x00")   # cmdline (512 bytes)
hdr += b"\x00" * 32                 # id (32 bytes / 8x uint32)
hdr += b"\x00" * 1024               # extra_cmdline (1024 bytes)

hdr = hdr.ljust(page_size, b"\x00")

def pad(b, ps):
    rem = len(b) % ps
    return b + (b"\x00" * (ps - rem) if rem else b"")

with open(boot_path, "wb") as f:
    f.write(hdr)
    f.write(pad(k_bytes, page_size))
    f.write(pad(r_bytes, page_size))
'
fi

# Generate SHA256 checksum
sha256sum "${BOOT_IMG}" > "${BOOT_IMG}.sha256"

echo "Candidate boot image generated successfully: ${BOOT_IMG}"
echo "Running boot image validator..."
python3 "${ROOT_DIR}/tools/boot/validate_boot_image.py" "${BOOT_IMG}"
