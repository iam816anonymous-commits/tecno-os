#!/usr/bin/env python3
"""
Host Test: Validate Initramfs /init Shebang Syntax
"""
from pathlib import Path

def test_initramfs_shebang():
    repo_root = Path(__file__).resolve().parent.parent.parent
    init_script = repo_root / "build" / "intermediate" / "rootfs" / "init"

    # Run build-rootfs.sh if intermediate init doesn't exist
    if not init_script.exists():
        import subprocess
        subprocess.run(["bash", str(repo_root / "build" / "build-rootfs.sh")], check=True)

    assert init_script.exists(), "Init script missing"

    lines = init_script.read_text().splitlines()
    assert len(lines) > 0, "Init script is empty"

    shebang = lines[0].strip()
    assert shebang == "#!/bin/sh", f"Invalid init shebang '{shebang}'. Must be '#!/bin/sh'"
    print("test_initramfs_shebang PASSED")

if __name__ == "__main__":
    test_initramfs_shebang()
