#!/usr/bin/env python3
"""
Host Test: Validate Minimal Initramfs Root Filesystem Generation
"""
import subprocess
from pathlib import Path

def test_initramfs():
    repo_root = Path(__file__).resolve().parent.parent.parent
    rootfs_script = repo_root / "build" / "build-rootfs.sh"

    assert rootfs_script.exists(), "build-rootfs.sh missing"

    res = subprocess.run(["bash", str(rootfs_script)], capture_output=True, text=True)
    assert res.returncode == 0, f"build-rootfs.sh failed:\n{res.stderr}"

    initramfs_artifact = repo_root / "build" / "artifacts" / "initramfs.cpio.gz"
    assert initramfs_artifact.exists(), "initramfs.cpio.gz artifact missing"
    assert initramfs_artifact.stat().st_size > 0, "initramfs.cpio.gz artifact is 0 bytes"

    print("test_initramfs PASSED")

if __name__ == "__main__":
    test_initramfs()
