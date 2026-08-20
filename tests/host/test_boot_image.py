#!/usr/bin/env python3
"""
Host Test: Validate Candidate Boot Image Creation and Inspection
"""
import subprocess
from pathlib import Path

def test_boot_image():
    repo_root = Path(__file__).resolve().parent.parent.parent
    build_image_script = repo_root / "build" / "build-image.sh"
    validator_script = repo_root / "tools" / "boot" / "validate_boot_image.py"

    assert build_image_script.exists(), "build-image.sh missing"
    assert validator_script.exists(), "validate_boot_image.py missing"

    # Run build-image.sh
    res = subprocess.run(["bash", str(build_image_script)], capture_output=True, text=True)
    assert res.returncode == 0, f"build-image.sh failed:\n{res.stderr}"

    boot_img = repo_root / "build" / "artifacts" / "boot.img"
    assert boot_img.exists(), "boot.img artifact missing"

    # Run validator
    val_res = subprocess.run(["python3", str(validator_script), str(boot_img)], capture_output=True, text=True)
    assert val_res.returncode == 0, f"validate_boot_image.py failed:\n{val_res.stderr}"

    print("test_boot_image PASSED")

if __name__ == "__main__":
    test_boot_image()
