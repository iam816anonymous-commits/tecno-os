#!/usr/bin/env python3
"""
Host Test: Validate Kernel Configuration Options
"""
from pathlib import Path

def test_kernel_config():
    repo_root = Path(__file__).resolve().parent.parent.parent
    config_file = repo_root / "kernel" / "configs" / "in6-stock-defconfig"

    assert config_file.exists(), "Stock kernel config file is missing"
    assert config_file.stat().st_size > 0, "Stock kernel config file is empty"

    text = config_file.read_text()
    assert "CONFIG_ARM64=y" in text, "Missing CONFIG_ARM64 in kernel defconfig"
    assert 'CONFIG_CUSTOM_TRAN_PROJECT="tran_in6"' in text, "Missing CONFIG_CUSTOM_TRAN_PROJECT in kernel defconfig"
    assert "CONFIG_ARCH_MEDIATEK=y" in text, "Missing CONFIG_ARCH_MEDIATEK in kernel defconfig"

    print("test_kernel_config PASSED")

if __name__ == "__main__":
    test_kernel_config()
