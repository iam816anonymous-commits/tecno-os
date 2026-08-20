#!/usr/bin/env python3
"""
IN6-Linux Non-Destructive Real Hardware Telemetry Collector
Parses and formats device diagnostic outputs captured over USB Serial Gadget (/dev/ttyGS0) or ADB.
"""
import sys
import json
import time
from pathlib import Path

def collect_telemetry(raw_log_path: Path, output_report_path: Path):
    if not raw_log_path.exists():
        print(f"Error: Log file '{raw_log_path}' does not exist.")
        return False

    raw_text = raw_log_path.read_text(errors="ignore")

    report = {
        "timestamp": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
        "target": "TECNO IN6 / H633 (MT6763)",
        "kernel_executed": "IN6-LINUX BRING-UP" in raw_text or "Linux version" in raw_text,
        "cpuinfo_detected": "Cortex-A53" in raw_text or "MT6763" in raw_text,
        "initramfs_mounted": "Executing Bring-Up Shell" in raw_text,
        "storage_detected": "mmcblk0" in raw_text,
        "evidence_classification": "DEVICE-VALIDATED" if ("IN6-LINUX BRING-UP" in raw_text) else "HOST-VALIDATED",
        "raw_summary": raw_text[:512]
    }

    output_report_path.write_text(json.dumps(report, indent=2))
    print(f"Device evidence formatted and written to {output_report_path}")
    return True

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: collect_device_evidence.py <raw_log.txt> <output_report.json>")
        sys.exit(1)

    log_in = Path(sys.argv[1])
    report_out = Path(sys.argv[2])
    if not collect_telemetry(log_in, report_out):
        sys.exit(1)
