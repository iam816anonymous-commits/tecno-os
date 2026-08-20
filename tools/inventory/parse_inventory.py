#!/usr/bin/env python3
"""
IN6-Linux Inventory Subsystem Parser & Validation Tool
"""
import sys
from pathlib import Path

def validate_inventory(inventory_dir: Path):
    required_files = [
        "getprop.txt", "cpuinfo.txt", "loaded-modules.txt",
        "partitions.txt", "mount.txt", "uname.txt"
    ]
    missing = []
    for fname in required_files:
        fpath = inventory_dir / fname
        if not fpath.exists() or fpath.stat().st_size == 0:
            missing.append(fname)

    if missing:
        print(f"Error: Missing or empty inventory files: {missing}")
        return False
    print("All inventory baseline files validated successfully.")
    return True

if __name__ == "__main__":
    inv_dir = Path(__file__).resolve().parent.parent.parent / "inventory"
    if not validate_inventory(inv_dir):
        sys.exit(1)
