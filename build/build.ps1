# PowerShell wrapper for IN6-Linux build system on Windows
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host "=================================================="
Write-Host "IN6-Linux Build Pipeline Wrapper (PowerShell)"
Write-Host "=================================================="

$rootDir = Split-Path -Parent $PSScriptRoot

if (Get-Command wsl.exe -ErrorAction SilentlyContinue) {
    Write-Host "Executing build verification in WSL environment..."
    wsl bash -c "cd '$rootDir' && bash build/verify.sh"
} else {
    Write-Host "WSL not detected. Running host-side file structure validation..."

    $requiredFiles = @(
        "README.md",
        "docs/hardware-compatibility.md",
        "device/tecno/in6/dts/mt6763-tecno-in6.dts",
        "build/verify.sh"
    )

    foreach ($file in $requiredFiles) {
        $path = Join-Path $rootDir $file
        if (-not (Test-Path $path)) {
            Write-Error "Missing required file: $file"
        }
    }
    Write-Host "Host-side structure check passed."
}
