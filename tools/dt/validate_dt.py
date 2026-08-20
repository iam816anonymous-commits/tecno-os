#!/usr/bin/env python3
"""
IN6-Linux Device Tree Validation & Constraint Checker Tool
"""
import sys
import subprocess
from pathlib import Path

def test_dts_compile(dts_file: Path):
    if not dts_file.exists():
        print(f"Error: DTS file {dts_file} does not exist.")
        return False

    preprocessed = Path("/tmp/in6_tool_test.dts")
    try:
        subprocess.run(["cpp", "-P", "-undef", "-x", "assembler-with-cpp", str(dts_file), str(preprocessed)], check=True)
        subprocess.run(["dtc", "-I", "dts", "-O", "dtb", "-o", "/dev/null", str(preprocessed)], check=True)
        print(f"DTS file {dts_file.name} validated successfully with dtc.")
        return True
    except subprocess.CalledProcessError as e:
        print(f"Error compiling DTS: {e}")
        return False
    finally:
        if preprocessed.exists():
            preprocessed.unlink()

if __name__ == "__main__":
    repo_root = Path(__file__).resolve().parent.parent.parent
    dts_target = repo_root / "device" / "tecno" / "in6" / "dts" / "mt6763-tecno-in6.dts"
    if not test_dts_compile(dts_target):
        sys.exit(1)
