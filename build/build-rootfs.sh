#!/usr/bin/env bash
# IN6-Linux Root Filesystem Skeleton Generator
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

ROOTFS_DIR="${ROOT_DIR}/build/intermediate/rootfs"
ARTIFACTS_DIR="${ROOT_DIR}/build/artifacts"

mkdir -p "${ARTIFACTS_DIR}"
rm -rf "${ROOTFS_DIR}"
mkdir -p "${ROOTFS_DIR}"/{bin,sbin,dev,proc,sys,etc,mnt,root,usr/bin,usr/sbin}

echo "=================================================="
echo "Generating Root Filesystem Skeleton"
echo "=================================================="

# Create minimal init script
cat << 'EOF' > "${ROOTFS_DIR}/init"
#!/bin/sh
# Minimal IN6-Linux Phase 1 Research Init Script
export PATH=/bin:/sbin:/usr/bin:/usr/sbin

mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -t devtmpfs devtmpfs /dev

echo "=================================================="
echo "         Welcome to IN6-Linux (MT6763)            "
echo "=================================================="
echo "Device: TECNO IN6 / H633"
echo "Kernel: $(uname -r)"

exec /bin/sh
EOF

chmod +x "${ROOTFS_DIR}/init"

# Create minimal cpio initramfs archive
(cd "${ROOTFS_DIR}" && find . -print0 | cpio --null -ov --format=newc | gzip -9 > "${ARTIFACTS_DIR}/initramfs.cpio.gz")

echo "Initramfs generated successfully: ${ARTIFACTS_DIR}/initramfs.cpio.gz"
