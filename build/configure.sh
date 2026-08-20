#!/usr/bin/env bash
# IN6-Linux Build Infrastructure README & Configuration Overview
set -euo pipefail

echo "=================================================="
echo "IN6-Linux Build Environment Configuration"
echo "=================================================="

# Create necessary build output directories
mkdir -p build/artifacts build/logs build/intermediate

# Detect required toolchain dependencies
MISSING_TOOLS=()

for tool in gcc dtc cpp u-boot-tools; do
    if ! command -v "$tool" &> /dev/null; then
        if [ "$tool" = "u-boot-tools" ]; then
            if ! command -v mkimage &> /dev/null; then
                MISSING_TOOLS+=("mkimage (u-boot-tools)")
            fi
        else
            MISSING_TOOLS+=("$tool")
        fi
    fi
done

if [ ${#MISSING_TOOLS[@]} -ne 0 ]; then
    echo "Warning: The following host tool dependencies are missing:"
    for m in "${MISSING_TOOLS[@]}"; do
        echo "  - $m"
    done
    echo "Please install them via: sudo apt-get install device-tree-compiler u-boot-tools gcc"
else
    echo "All core build host dependencies (gcc, dtc, cpp, mkimage) are detected."
fi

# Export build environment variables
export ARCH=arm64
export CROSS_COMPILE=${CROSS_COMPILE:-aarch64-linux-gnu-}
export BUILD_DIR="$(pwd)/build"
export ARTIFACTS_DIR="$(pwd)/build/artifacts"

echo "Build environment initialized successfully."
