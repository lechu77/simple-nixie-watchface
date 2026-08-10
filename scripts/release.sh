#!/usr/bin/env bash
set -e

# Simple Nixie Garmin Connect IQ Watch Face Release Script
# Builds an .iq package for upload to the Connect IQ Store

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
            echo "Error: monkeyc compiler not found."
            exit 1
        fi
    fi
fi

# Ensure developer key is provided or exists
DEFAULT_KEY="/Users/z0051syf/workspace/Lechu/Garmin/lechu-developer_key.der"
KEY_FILE="${1:-$DEFAULT_KEY}"

if [ -z "$KEY_FILE" ]; then
    echo "Error: You must provide the path to your developer_key.der!"
    echo "Usage: ./scripts/release.sh /path/to/your/developer_key.der"
    exit 1
fi

if [ ! -f "$KEY_FILE" ]; then
    echo "Error: Developer key not found at $KEY_FILE!"
    exit 1
fi

PROJECT_NAME=$(basename "$PROJECT_ROOT")
OUTPUT_DIR="${2:-bin}"
LOCAL_IQ="bin/${PROJECT_NAME}.iq"

mkdir -p bin

echo "Building release package (${PROJECT_NAME}.iq) for Connect IQ Store..."
echo "  Compiler: $MONKEYC"
echo "  Output: $LOCAL_IQ"

"$MONKEYC" \
    -f monkey.jungle \
    -o "$LOCAL_IQ" \
    -y "$KEY_FILE" \
    -e \
    -w \
    -l 3 \
    -r

if [ -f "$LOCAL_IQ" ]; then
    echo "Release build successful! Package created at: $LOCAL_IQ"
    if [ "$OUTPUT_DIR" != "bin" ]; then
        mkdir -p "$OUTPUT_DIR"
        cp "$LOCAL_IQ" "$OUTPUT_DIR/"
        echo "Package copied to: $OUTPUT_DIR/${PROJECT_NAME}.iq"
    fi
    echo "You can now upload this file to the Garmin Connect IQ Developer Dashboard."
else
    echo "Build failed!"
    exit 1
fi
