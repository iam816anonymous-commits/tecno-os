#!/usr/bin/env bash
# IN6-Linux Kernel & Device Tree Compilation Script
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

DTS_SRC="${ROOT_DIR}/device/tecno/in6/dts/mt6763-tecno-in6.dts"
ARTIFACTS_DIR="${ROOT_DIR}/build/artifacts"
INTERMEDIATE_DIR="${ROOT_DIR}/build/intermediate"

mkdir -p "${ARTIFACTS_DIR}" "${INTERMEDIATE_DIR}"

echo "=================================================="
echo "Compiling IN6 Device Tree (mt6763-tecno-in6.dts)"
echo "=================================================="

# Preprocess DTS using C preprocessor (-undef prevents cpp from expanding keywords like 'linux')
cpp -P -undef -x assembler-with-cpp "${DTS_SRC}" "${INTERMEDIATE_DIR}/mt6763-tecno-in6.pp.dts"

# Compile DTS to DTB binary
dtc -I dts -O dtb -o "${ARTIFACTS_DIR}/mt6763-tecno-in6.dtb" "${INTERMEDIATE_DIR}/mt6763-tecno-in6.pp.dts"

echo "DTB compiled successfully: ${ARTIFACTS_DIR}/mt6763-tecno-in6.dtb"

# Create mock kernel image artifact if kernel build tree is absent
if [ ! -f "${ARTIFACTS_DIR}/Image.gz" ]; then
    echo "Creating research placeholder kernel image artifact (Image.gz)..."
    echo "IN6-Linux Kernel Placeholder Image v0.1" | gzip > "${ARTIFACTS_DIR}/Image.gz"
fi

echo "Kernel & DTS compilation step complete."
