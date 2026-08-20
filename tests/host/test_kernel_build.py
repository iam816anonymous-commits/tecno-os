#!/usr/bin/env python3
"""
Host Test: Validate Real Kernel and DTB Compilation Pipeline Execution
Enforces that built Image.gz is a real compressed kernel payload (> 100KB) and not a fake text file.
"""
import gzip
import subprocess
from pathlib import Path

def test_kernel_build():
    repo_root = Path(__file__).resolve().parent.parent.parent
    build_script = repo_root / "build" / "build-kernel.sh"

    assert build_script.exists(), "build-kernel.sh does not exist"

    # Execute build-kernel.sh
    res = subprocess.run(["bash", str(build_script)], capture_output=True, text=True)
    assert res.returncode == 0, f"build-kernel.sh failed with error:\n{res.stderr}"

    dtb_artifact = repo_root / "build" / "artifacts" / "mt6763-tecno-in6.dtb"
    assert dtb_artifact.exists(), "Compiled DTB artifact missing"
    assert dtb_artifact.stat().st_size > 0, "Compiled DTB artifact is 0 bytes"

    kernel_artifact = repo_root / "build" / "artifacts" / "Image.gz"
    assert kernel_artifact.exists(), "Kernel Image.gz artifact missing"

    # Verify Image.gz is a real decompressed kernel binary larger than 100KB (rejecting text placeholder hacks)
    decompressed_data = gzip.decompress(kernel_artifact.read_bytes())
    assert len(decompressed_data) > 100000, f"Kernel Image.gz payload size ({len(decompressed_data)} bytes) is too small to be a real kernel binary (fake placeholder detected)"

    print("test_kernel_build PASSED")

if __name__ == "__main__":
    test_kernel_build()
