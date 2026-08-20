#!/usr/bin/env python3
"""
Host Test: Validate Kernel and DTB Compilation Pipeline Execution
"""
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

    print("test_kernel_build PASSED")

if __name__ == "__main__":
    test_kernel_build()
