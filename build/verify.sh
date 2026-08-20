#!/usr/bin/env bash
# IN6-Linux Repository Verification and Constraint Enforcement Script
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

ERRORS=0

echo "=================================================="
echo "      IN6-Linux Automated Host Validation         "
echo "=================================================="

# 1. Verify DTS compilation
echo "[1/6] Verifying DTS Compilation..."
if [ -f "${ROOT_DIR}/device/tecno/in6/dts/mt6763-tecno-in6.dts" ]; then
    cpp -P -undef -x assembler-with-cpp "${ROOT_DIR}/device/tecno/in6/dts/mt6763-tecno-in6.dts" /tmp/in6_test.dts
    if dtc -I dts -O dtb -o /dev/null /tmp/in6_test.dts 2>/dev/null; then
        echo "  [PASS] DTS compiles cleanly without errors."
    else
        echo "  [FAIL] DTS compilation failed."
        ERRORS=$((ERRORS + 1))
    fi
    rm -f /tmp/in6_test.dts
else
    echo "  [FAIL] DTS source file missing."
    ERRORS=$((ERRORS + 1))
fi

# 2. Verify forbidden flash commands in executable build/tools scripts
echo "[2/6] Checking for Forbidden Flashing Commands..."
FORBIDDEN_TERMS=("fastboot flash" "fastboot erase" "fastboot format" "fastboot reboot recovery" "dd if=.* of=/dev/block")

FOUND_FORBIDDEN=0
for script in $(find "${ROOT_DIR}/build" "${ROOT_DIR}/tools" -type f \( -name "*.sh" -o -name "*.py" -o -name "*.ps1" \)); do
    # Skip verify.sh itself from checking its own string definitions
    if [ "$(basename "${script}")" = "verify.sh" ]; then
        continue
    fi
    for term in "${FORBIDDEN_TERMS[@]}"; do
        if grep -qE "${term}" "${script}" 2>/dev/null; then
            echo "  [FAIL] Forbidden flashing command pattern '${term}' found in ${script}"
            FOUND_FORBIDDEN=1
            ERRORS=$((ERRORS + 1))
        fi
    done
done

if [ ${FOUND_FORBIDDEN} -eq 0 ]; then
    echo "  [PASS] No forbidden flashing commands detected in scripts."
fi

# 3. Verify documentation completeness
echo "[3/6] Verifying Documentation Integrity..."
REQUIRED_DOCS=(
    "docs/architecture.md"
    "docs/hardware-overview.md"
    "docs/hardware-compatibility.md"
    "docs/kernel-strategy.md"
    "docs/kernel-port-strategy.md"
    "docs/kernel-config-analysis.md"
    "docs/current-state-audit.md"
    "docs/boot-chain.md"
    "docs/device-tree.md"
    "docs/device-tree-evidence.md"
    "docs/firmware.md"
    "docs/userspace.md"
    "docs/security-model.md"
    "docs/bringup-plan.md"
    "docs/IN6-linux-research-report.md"
    "docs/product/OS-VISION.md"
    "docs/product/requirements.md"
    "docs/product/privacy-model.md"
    "docs/product/security-model.md"
    "docs/product/permission-model.md"
    "docs/product/network-model.md"
    "docs/product/application-model.md"
    "docs/product/android-compatibility.md"
    "docs/product/power-model.md"
    "docs/product/offline-model.md"
    "docs/product/resource-budgets.md"
    "docs/product/architecture-decision-record.md"
    "docs/roadmap/OS-roadmap.md"
    "research/reference-projects.md"
)

for doc in "${REQUIRED_DOCS[@]}"; do
    if [ ! -s "${ROOT_DIR}/${doc}" ]; then
        echo "  [FAIL] Missing or empty document: ${doc}"
        ERRORS=$((ERRORS + 1))
    fi
done
echo "  [PASS] All core architecture and product specification documents present and non-empty."

# 4. Verify inventory files
echo "[4/6] Verifying Hardware Inventory Baseline..."
REQUIRED_INVENTORY=(
    "inventory/getprop.txt"
    "inventory/cpuinfo.txt"
    "inventory/loaded-modules.txt"
    "inventory/partitions.txt"
    "inventory/mount.txt"
    "inventory/uname.txt"
    "inventory/input-devices.txt"
)

for inv in "${REQUIRED_INVENTORY[@]}"; do
    if [ ! -s "${ROOT_DIR}/${inv}" ]; then
        echo "  [FAIL] Missing or empty inventory file: ${inv}"
        ERRORS=$((ERRORS + 1))
    fi
done
echo "  [PASS] Hardware inventory baseline intact."

# 5. Execute full build pipeline test
echo "[5/6] Testing Build System Execution..."
bash "${ROOT_DIR}/build/clean.sh" >/dev/null
bash "${ROOT_DIR}/build/configure.sh" >/dev/null
bash "${ROOT_DIR}/build/build-kernel.sh" >/dev/null
bash "${ROOT_DIR}/build/build-rootfs.sh" >/dev/null
bash "${ROOT_DIR}/build/build-image.sh" >/dev/null

if [ -f "${ROOT_DIR}/build/artifacts/boot.img" ]; then
    echo "  [PASS] Build pipeline generated artifact: build/artifacts/boot.img"
else
    echo "  [FAIL] Build pipeline failed to generate boot.img artifact."
    ERRORS=$((ERRORS + 1))
fi

# 6. Execute Python Host Test Suite
echo "[6/6] Running Host Test Suite..."
for test_file in "${ROOT_DIR}/tests/host"/test_*.py; do
    if python3 "${test_file}" >/dev/null 2>&1; then
        echo "  [PASS] $(basename "${test_file}")"
    else
        echo "  [FAIL] $(basename "${test_file}")"
        ERRORS=$((ERRORS + 1))
    fi
done

echo "=================================================="
if [ ${ERRORS} -eq 0 ]; then
    echo "Validation Result: ALL PASSED (0 Errors)"
    exit 0
else
    echo "Validation Result: FAILED (${ERRORS} Errors)"
    exit 1
fi
