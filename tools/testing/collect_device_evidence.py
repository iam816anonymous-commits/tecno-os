#!/usr/bin/env python3
"""
IN6-Linux Non-Destructive Real Hardware Telemetry Collector
Parses ADB shell diagnostic dumps and formats an evidence-classified manifest.
"""
import sys
import json
import time
from pathlib import Path

def generate_telemetry_manifest(log_text: str) -> dict:
    manifest = {
        "timestamp": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
        "target": "TECNO IN6 / H633 (MediaTek MT6763)",
        "adbd_root": "PERMISSION DENIED" if "cannot run as root" in log_text or "Permission denied" in log_text else "ACCESSIBLE",
        "nodes": {
            "getprop": "ACCESSIBLE" if "ro.product.model" in log_text or "TECNO" in log_text else "UNKNOWN",
            "cpuinfo": "ACCESSIBLE" if "Cortex-A53" in log_text or "MT6763" in log_text else "UNKNOWN",
            "proc_partitions": "ACCESSIBLE" if "mmcblk0" in log_text else "PERMISSION DENIED",
            "boot_block_device": "PERMISSION DENIED" if "Permission denied" in log_text else "UNKNOWN",
            "input_devices": "ACCESSIBLE" if "mtk-kpd" in log_text or "pmic_keys" in log_text else "UNKNOWN",
            "wireless_modules": "ACCESSIBLE" if "wlan_drv_gen2" in log_text or "bt_drv" in log_text else "UNKNOWN"
        },
        "execution_status": "DEVICE-VALIDATED" if "IN6-LINUX BRING-UP" in log_text else "HOST-VALIDATED",
        "has_kernel_executed_on_device": False
    }
    return manifest

def main():
    repo_root = Path(__file__).resolve().parent.parent.parent
    sample_log = repo_root / "inventory" / "getprop.txt"
    out_manifest = repo_root / "inventory" / "device-telemetry-manifest.json"

    log_data = sample_log.read_text() if sample_log.exists() else ""
    manifest = generate_telemetry_manifest(log_data)

    out_manifest.write_text(json.dumps(manifest, indent=2))
    print(f"Device telemetry manifest written to {out_manifest}")

if __name__ == "__main__":
    main()
