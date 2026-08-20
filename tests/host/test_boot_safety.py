#!/usr/bin/env python3
"""
Host Test 3: Validate Flashing Safety & Non-Destructive Script Policies
"""
import re
from pathlib import Path

def test_flashing_safety():
    repo_root = Path(__file__).resolve().parent.parent.parent

    forbidden_patterns = [
        r"fastboot\s+flash",
        r"fastboot\s+erase",
        r"fastboot\s+format",
        r"fastboot\s+reboot\s+recovery",
        r"fastboot\s+set_active",
        r"fastboot\s+--disable-verity",
        r"fastboot\s+--disable-verification",
        r"dd\s+if=.*of=/dev/block",
        r"parted\b",
        r"mkfs\b",
        r"sgdisk\s+.*write",
        r"blockdev\s+--setrw"
    ]

    target_dirs = [repo_root / "build", repo_root / "tools", repo_root / "device"]

    for tdir in target_dirs:
        if not tdir.exists():
            continue
        for fpath in tdir.rglob("*"):
            if fpath.is_file() and fpath.name != "verify.sh" and fpath.suffix in [".sh", ".py", ".ps1"]:
                text = fpath.read_text()
                for pattern in forbidden_patterns:
                    match = re.search(pattern, text)
                    assert not match, f"Forbidden flashing command '{match.group(0)}' found in {fpath}"

    print("test_flashing_safety PASSED")

if __name__ == "__main__":
    test_flashing_safety()
