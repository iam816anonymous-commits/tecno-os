#!/usr/bin/env python3
"""
Host Test 2: Validate Device Tree Compilation and Placeholder Annotations
"""
import subprocess
from pathlib import Path

def test_dts_compilation():
    repo_root = Path(__file__).resolve().parent.parent.parent
    dts_file = repo_root / "device" / "tecno" / "in6" / "dts" / "mt6763-tecno-in6.dts"

    assert dts_file.exists(), "DTS file does not exist"

    # Check that unknown properties use mandatory placeholders
    content = dts_file.read_text() + (dts_file.parent / "mt6763-tecno-in6.dtsi").read_text()
    assert "REQUIRES_IN6_MEASUREMENT" in content, "Missing REQUIRES_IN6_MEASUREMENT placeholder in DTS/DTSI"

    # Run dtc test
    pp = Path("/tmp/test_dts_compilation.dts")
    try:
        subprocess.run(["cpp", "-P", "-undef", "-x", "assembler-with-cpp", str(dts_file), str(pp)], check=True)
        subprocess.run(["dtc", "-I", "dts", "-O", "dtb", "-o", "/dev/null", str(pp)], check=True)
    finally:
        if pp.exists():
            pp.unlink()

    print("test_dts_compilation PASSED")

if __name__ == "__main__":
    test_dts_compilation()
