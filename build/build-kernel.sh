#!/usr/bin/env bash
# IN6-Linux Kernel & Device Tree Compilation Script
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

DTS_SRC="${ROOT_DIR}/device/tecno/in6/dts/mt6763-tecno-in6.dts"
ARTIFACTS_DIR="${ROOT_DIR}/build/artifacts"
INTERMEDIATE_DIR="${ROOT_DIR}/build/intermediate"
KERNEL_SRC_DIR="${KERNEL_SRC_DIR:-${ROOT_DIR}/kernel/src}"

mkdir -p "${ARTIFACTS_DIR}" "${INTERMEDIATE_DIR}"

echo "=================================================="
echo "Compiling IN6 Device Tree (mt6763-tecno-in6.dts)"
echo "=================================================="

# Preprocess DTS using C preprocessor (-undef prevents cpp from expanding keywords like 'linux')
cpp -P -undef -x assembler-with-cpp "${DTS_SRC}" "${INTERMEDIATE_DIR}/mt6763-tecno-in6.pp.dts"

# Compile DTS to DTB binary
dtc -I dts -O dtb -o "${ARTIFACTS_DIR}/mt6763-tecno-in6.dtb" "${INTERMEDIATE_DIR}/mt6763-tecno-in6.pp.dts"

echo "DTB compiled successfully: ${ARTIFACTS_DIR}/mt6763-tecno-in6.dtb"

echo "=================================================="
echo "Building Real ARM64 IN6 Linux Kernel Image"
echo "=================================================="

# Verify real kernel source directory exists
if [ ! -d "${KERNEL_SRC_DIR}" ] || [ ! -f "${KERNEL_SRC_DIR}/Makefile" ]; then
    echo "Error: Real kernel source tree not found at ${KERNEL_SRC_DIR}."
    echo "Please run 'git submodule update --init --recursive' or clone MT6763 kernel source to kernel/src."
    echo "Strict Directive: Fake or placeholder kernel payload creation is permanently prohibited."
    exit 1
fi

echo "Found real kernel source tree at ${KERNEL_SRC_DIR}."

# Configure kernel with IN6 stock defconfig baseline
if [ -f "${ROOT_DIR}/kernel/configs/in6-stock-defconfig" ]; then
    echo "Applying IN6 stock defconfig..."
    cp "${ROOT_DIR}/kernel/configs/in6-stock-defconfig" "${KERNEL_SRC_DIR}/arch/arm64/configs/in6_defconfig"
    make -C "${KERNEL_SRC_DIR}" ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- in6_defconfig
fi

# Build ARM64 gzip-compressed Image.gz
echo "Compiling ARM64 kernel Image.gz using aarch64-linux-gnu-gcc..."
make -C "${KERNEL_SRC_DIR}" ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- Image.gz -j"$(nproc)"

if [ ! -f "${KERNEL_SRC_DIR}/arch/arm64/boot/Image.gz" ]; then
    echo "Error: Kernel build failed to produce ${KERNEL_SRC_DIR}/arch/arm64/boot/Image.gz"
    exit 1
fi

cp "${KERNEL_SRC_DIR}/arch/arm64/boot/Image.gz" "${ARTIFACTS_DIR}/Image.gz"

# Verify built artifact is a valid gzip file
if ! gzip -t "${ARTIFACTS_DIR}/Image.gz" 2>/dev/null; then
    echo "Error: Generated Image.gz artifact is not a valid gzip archive."
    exit 1
fi

echo "Real ARM64 kernel built and verified successfully: ${ARTIFACTS_DIR}/Image.gz"
echo "Kernel & DTS compilation step complete."
