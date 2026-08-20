#!/usr/bin/env bash
# IN6-Linux Build Directory Clean Script
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "Cleaning build directory..."
rm -rf "${ROOT_DIR}/build/artifacts"/*
rm -rf "${ROOT_DIR}/build/intermediate"/*
rm -rf "${ROOT_DIR}/build/logs"/*

echo "Build directory cleaned."
