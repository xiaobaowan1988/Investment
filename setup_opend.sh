#!/bin/bash
# One-time setup: generate RSA key and pull Docker image

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
KEY_FILE="$SCRIPT_DIR/futu.pem"

echo "=== Moomoo OpenD Setup ==="

# Generate RSA key if not exists
if [ ! -f "$KEY_FILE" ]; then
    echo "[1/2] Generating RSA key..."
    openssl genrsa -out "$KEY_FILE" 1024
    chmod 600 "$KEY_FILE"
    echo "      RSA key saved to $KEY_FILE"
else
    echo "[1/2] RSA key already exists: $KEY_FILE"
fi

# Pull Docker image
echo "[2/2] Pulling OpenD Docker image..."
docker pull ostai/futuopend:latest

echo ""
echo "Setup complete. Run ./start_opend.sh to start OpenD."
