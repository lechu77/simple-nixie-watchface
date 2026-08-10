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

# Check for developer key (optional for local testing, required for export)
DEFAULT_KEY="/Users/z0051syf/workspace/Lechu/Garmin/lechu-developer_key.der"
KEY_FILE="${2:-$DEFAULT_KEY}"
KEY_FLAG=""
if [ -f "$KEY_FILE" ]; then
    KEY_FLAG="-y $KEY_FILE"
else
    echo "Notice: No developer key found/provided. Building without signing (sufficient for simulator)."
fi

DEVICE="${1:-fenix8pro47mm}"
PROJECT_NAME=$(basename "$PROJECT_ROOT")
OUTPUT_DIR="${3:-bin}"
LOCAL_PRG="bin/${PROJECT_NAME}.prg"

mkdir -p bin

echo "Building Simple Nixie watch face..."
echo "  Compiler: $MONKEYC"
echo "  Target Device: $DEVICE"
echo "  Output: $LOCAL_PRG"

"$MONKEYC" \
    -f monkey.jungle \
    -o "$LOCAL_PRG" \
    -d "$DEVICE" \
    $KEY_FLAG \
    -w \
    -l 3

if [ -f "$LOCAL_PRG" ]; then
    echo "Build successful! Binary created at: $LOCAL_PRG"
    if [ "$OUTPUT_DIR" != "bin" ]; then
        mkdir -p "$OUTPUT_DIR"
        cp "$LOCAL_PRG" "$OUTPUT_DIR/"
        echo "Binary copied to: $OUTPUT_DIR/${PROJECT_NAME}.prg"
    fi
else
    echo "Build failed!"
    exit 1
fi
