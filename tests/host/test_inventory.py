#!/usr/bin/env python3
"""
Host Test 1: Validate Hardware Inventory Files
"""
import sys
from pathlib import Path

def test_inventory():
    repo_root = Path(__file__).resolve().parent.parent.parent
    inventory_dir = repo_root / "inventory"

    files = [
        "getprop.txt", "cpuinfo.txt", "loaded-modules.txt",
        "input-devices.txt", "partitions.txt", "mount.txt",
        "uname.txt", "wireless.txt", "audio.txt"
    ]

    for fname in files:
        fpath = inventory_dir / fname
        assert fpath.exists(), f"Missing inventory file: {fname}"
        assert fpath.stat().st_size > 0, f"Empty inventory file: {fname}"

    print("test_inventory PASSED")

if __name__ == "__main__":
    test_inventory()
