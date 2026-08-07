#!/usr/bin/env bash
set -e

# Simple Nixie Garmin Connect IQ Watch Face Build Script
# Target SDK: Connect IQ SDK 9.2
# Primary Target: Garmin Fenix 8 AMOLED (fenix8pro47mm)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

# Locate monkeyc compiler
if command -v monkeyc &> /dev/null; then
    MONKEYC="monkeyc"
else
    SDK_DIR="$HOME/Library/Application Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2"
    if [ -f "$SDK_DIR/bin/monkeyc" ]; then
        MONKEYC="$SDK_DIR/bin/monkeyc"
    else
        # Find latest SDK
        LATEST_SDK=$(find "$HOME/Library/Application Support/Garmin/ConnectIQ/Sdks" -name "monkeyc" 2>/dev/null | sort -V | tail -n 1)
        if [ -n "$LATEST_SDK" ]; then
            MONKEYC="$LATEST_SDK"
        else
            echo "Error: monkeyc compiler not found. Please install Connect IQ SDK 9.2."
            exit 1
        fi
    fi
fi

# Ensure developer key exists
KEY_FILE="$PROJECT_ROOT/developer_key.der"
if [ ! -f "$KEY_FILE" ]; then
    echo "Generating developer key (developer_key.der)..."
    PEM_KEY=$(mktemp)
    openssl genrsa -out "$PEM_KEY" 4096 2>/dev/null
    openssl pkcs8 -topk8 -inform PEM -outform DER -in "$PEM_KEY" -out "$KEY_FILE" -nocrypt 2>/dev/null
    rm -f "$PEM_KEY"
fi

DEVICE="${1:-fenix8pro47mm}"
OUTPUT_DIR="$PROJECT_ROOT/bin"
OUTPUT_PRG="$OUTPUT_DIR/simple-nixie.prg"

mkdir -p "$OUTPUT_DIR"

echo "Building Simple Nixie watch face..."
echo "  Compiler: $MONKEYC"
echo "  Target Device: $DEVICE"
echo "  Output: $OUTPUT_PRG"

"$MONKEYC" \
    -f monkey.jungle \
    -o "$OUTPUT_PRG" \
    -d "$DEVICE" \
    -y "$KEY_FILE" \
    -w \
    -l 3

if [ -f "$OUTPUT_PRG" ]; then
    echo "Build successful! Binary created at: $OUTPUT_PRG"
else
    echo "Build failed!"
    exit 1
fi
