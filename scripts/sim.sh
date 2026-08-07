#!/usr/bin/env bash
set -e

# Build and launch Simple Nixie in Connect IQ Simulator

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

# 1. Compile project
"$PROJECT_ROOT/scripts/build.sh"

SDK_DIR="$HOME/Library/Application Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2"
CONNECTIQ="$SDK_DIR/bin/connectiq"
MONKEYDO="$SDK_DIR/bin/monkeydo"

# 2. Start Connect IQ Simulator if not already running
if ! pgrep -f "ConnectIQ.app" > /dev/null; then
    echo "Starting Connect IQ Simulator..."
    "$CONNECTIQ" &
    sleep 3
fi

# 3. Load watchface binary into simulator
DEVICE="${1:-fenix8pro47mm}"
echo "Loading simple-nixie.prg into simulator ($DEVICE)..."
"$MONKEYDO" "$PROJECT_ROOT/bin/simple-nixie.prg" "$DEVICE"
