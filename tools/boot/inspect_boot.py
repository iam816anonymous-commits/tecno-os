#!/usr/bin/env python3
"""
IN6-Linux Android Boot Image Inspector Tool
Inspects Android Boot Image Header (v0/v1/v2) fields without flashing or altering files.
"""
import sys
import struct
import hashlib
from pathlib import Path

BOOT_MAGIC = b"ANDROID!"

def inspect_boot_image(filepath: Path):
    if not filepath.exists():
        print(f"Error: File '{filepath}' does not exist.")
        return False

    file_size = filepath.stat().st_size
    if file_size < 2048:
        print(f"Error: Image size ({file_size} bytes) is too small to contain a boot header.")
        return False

    with open(filepath, "rb") as f:
        data = f.read(2048)

    if not data.startswith(BOOT_MAGIC):
        print(f"Error: Magic header mismatch. Expected '{BOOT_MAGIC.decode()}', found '{data[:8]}'")
        return False

    # Unpack Android Header v0/v1/v2
    try:
        header = struct.unpack("<8sIIIIIIIIII", data[:48])
        magic, kernel_size, kernel_addr, ramdisk_size, ramdisk_addr, \
            second_size, second_addr, tags_addr, page_size, header_version, os_version = header

        cmdline = data[64:576].decode("ascii", errors="ignore").rstrip("\x00")
        name = data[576:592].decode("ascii", errors="ignore").rstrip("\x00")

        # Read SHA256 of full file
        sha256 = hashlib.sha256(filepath.read_bytes()).hexdigest()

        print("==================================================")
        print(f"     Android Boot Image Metadata Report           ")
        print("==================================================")
        print(f"File Path:            {filepath}")
        print(f"File Size:            {file_size} bytes")
        print(f"Header Classification: STRUCTURALLY VALID BOOT IMAGE")
        print(f"Magic:                {magic.decode('ascii')}")
        print(f"Header Version:       v{header_version}")
        print(f"Page Size:            {page_size} bytes")
        print(f"Kernel Size:          {kernel_size} bytes (Load Addr: 0x{kernel_addr:08x})")
        print(f"Ramdisk Size:         {ramdisk_size} bytes (Load Addr: 0x{ramdisk_addr:08x})")
        print(f"Second Size:          {second_size} bytes (Load Addr: 0x{second_addr:08x})")
        print(f"Tags Address:         0x{tags_addr:08x}")
        print(f"OS Version Raw:       0x{os_version:08x}")
        print(f"Board Name:           '{name}'")
        print(f"Command Line:         '{cmdline}'")
        print(f"SHA256 Checksum:      {sha256}")
        print("==================================================")
        return True

    except Exception as e:
        print(f"Error unpacking boot image header: {e}")
        return False

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: inspect_boot.py <path_to_boot.img>")
        sys.exit(1)

    target_img = Path(sys.argv[1])
    if not inspect_boot_image(target_img):
        sys.exit(1)
