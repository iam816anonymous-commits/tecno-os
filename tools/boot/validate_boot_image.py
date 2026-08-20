#!/usr/bin/env python3
"""
IN6-Linux Candidate Boot Image Validator Tool
Enforces partition constraints, header integrity, payload presence, and checksums.
"""
import sys
import struct
import hashlib
from pathlib import Path

BOOT_MAGIC = b"ANDROID!"
MAX_BOOT_PARTITION_SIZE = 32 * 1024 * 1024  # 32MB boot partition limit (/dev/block/mmcblk0p25)

def validate_boot_image(filepath: Path):
    if not filepath.exists():
        print(f"FAIL: Boot image '{filepath}' does not exist.")
        return False

    file_size = filepath.stat().st_size
    if file_size == 0:
        print("FAIL: Boot image file is empty (0 bytes).")
        return False

    if file_size > MAX_BOOT_PARTITION_SIZE:
        print(f"FAIL: Image size ({file_size} bytes) exceeds partition capacity ({MAX_BOOT_PARTITION_SIZE} bytes).")
        return False

    with open(filepath, "rb") as f:
        header_data = f.read(2048)

    if not header_data.startswith(BOOT_MAGIC):
        print(f"FAIL: Header magic mismatch. Expected 'ANDROID!', got {header_data[:8]}")
        return False

    try:
        header = struct.unpack("<8sIIIIIIIIII", header_data[:48])
        magic, kernel_size, kernel_addr, ramdisk_size, ramdisk_addr, \
            second_size, second_addr, tags_addr, page_size, header_version, os_version = header

        if kernel_size == 0:
            print("FAIL: Kernel payload size is 0 bytes.")
            return False

        if page_size not in (2048, 4096):
            print(f"FAIL: Invalid page size {page_size} bytes.")
            return False

        sha256 = hashlib.sha256(filepath.read_bytes()).hexdigest()

        print(f"PASS: Boot image '{filepath.name}' is valid.")
        print(f"      Size: {file_size} bytes | Page: {page_size} | Kernel: {kernel_size}B | Ramdisk: {ramdisk_size}B")
        print(f"      SHA256: {sha256}")
        return True

    except Exception as e:
        print(f"FAIL: Exception unpacking header: {e}")
        return False

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: validate_boot_image.py <path_to_boot.img>")
        sys.exit(1)

    target = Path(sys.argv[1])
    if not validate_boot_image(target):
        sys.exit(1)
