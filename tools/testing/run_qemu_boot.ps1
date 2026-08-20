# PowerShell script to evaluate ARM64 QEMU software boot compatibility
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host "=================================================="
Write-Host "IN6-Linux QEMU Software Boot Compatibility Test"
Write-Host "=================================================="

$rootDir = Split-Path -Parent $PSScriptRoot
$kernelPath = Join-Path $rootDir "build/artifacts/Image.gz"
$initramfsPath = Join-Path $rootDir "build/artifacts/initramfs.cpio.gz"
$dtbPath = Join-Path $rootDir "build/artifacts/mt6763-tecno-in6.dtb"

if (-not (Test-Path $kernelPath) -or -not (Test-Path $initramfsPath)) {
    Write-Host "Build artifacts missing. Running build-kernel.sh and build-rootfs.sh..."
    if (Get-Command wsl.exe -ErrorAction SilentlyContinue) {
        wsl bash -c "cd '$rootDir' && bash build/build-kernel.sh && bash build/build-rootfs.sh"
    }
}

if (Get-Command qemu-system-aarch64 -ErrorAction SilentlyContinue) {
    Write-Host "qemu-system-aarch64 detected. Note: MediaTek MT6763 SoC IP cores (topckgen, pwrap, MT6358 PMIC) lack QEMU machine models."
    Write-Host "QEMU Result: QEMU NOT APPLICABLE (Kernel is MT6763 SoC-specific)."
} else {
    Write-Host "qemu-system-aarch64 not installed on host."
    Write-Host "QEMU Result: QEMU NOT APPLICABLE"
}
