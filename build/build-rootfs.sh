#!/usr/bin/env bash
# IN6-Linux Root Filesystem Skeleton Generator
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

ROOTFS_DIR="${ROOT_DIR}/build/intermediate/rootfs"
ARTIFACTS_DIR="${ROOT_DIR}/build/artifacts"

mkdir -p "${ARTIFACTS_DIR}"
rm -rf "${ROOTFS_DIR}"
mkdir -p "${ROOTFS_DIR}"/{bin,sbin,dev,proc,sys,etc,mnt,tmp,root,usr/bin,usr/sbin}

echo "=================================================="
echo "Generating Minimal Bring-Up Initramfs"
echo "=================================================="

# Create minimal bring-up init script
cat << 'EOF' > "${ROOTFS_DIR}/init"
#!/bin/sh
# Minimal IN6-Linux Phase 1 Research & Diagnostic Init Script
export PATH=/bin:/sbin:/usr/bin:/usr/sbin

# Mount essential virtual filesystems
mount -t proc proc /proc 2>/dev/null || true
mount -t sysfs sysfs /sys 2>/dev/null || true
mount -t devtmpfs devtmpfs /dev 2>/dev/null || true

BUILD_HASH=$(cat /etc/build_hash 2>/dev/null || echo "DEVELOPMENT")

echo "=================================================="
echo "         IN6-LINUX BRING-UP                      "
echo "         TECNO IN6 / H633 (MT6763)               "
echo "=================================================="
echo "Kernel: $(uname -r 2>/dev/null || echo 'Linux 4.4.95+')"
echo "Build:  ${BUILD_HASH}"
echo "=================================================="

echo "[+] System Memory Baseline:"
cat /proc/meminfo 2>/dev/null | head -n 5 || echo "Memory stats unavailable"

echo "[+] Detected Block Devices:"
cat /proc/partitions 2>/dev/null || ls -l /dev/block 2>/dev/null || echo "Partitions unavailable"

echo "[+] Executing Bring-Up Shell..."
exec /bin/sh
EOF

chmod +x "${ROOTFS_DIR}/init"

# Record build metadata
echo "v0.1-candidate-$(date +%Y%m%d%H%M%S)" > "${ROOTFS_DIR}/etc/build_hash"

# Create cpio initramfs archive
(cd "${ROOTFS_DIR}" && find . -print0 | cpio --null -ov --format=newc | gzip -9 > "${ARTIFACTS_DIR}/initramfs.cpio.gz")

echo "Initramfs generated successfully: ${ARTIFACTS_DIR}/initramfs.cpio.gz"
