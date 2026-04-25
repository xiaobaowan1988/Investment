#!/bin/bash
# Start Moomoo OpenD via Docker

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
KEY_FILE="$SCRIPT_DIR/futu.pem"
CONTAINER_NAME="futu-opend"

# Check RSA key
if [ ! -f "$KEY_FILE" ]; then
    echo "RSA key not found. Run ./setup_opend.sh first."
    exit 1
fi

# Stop and remove existing container if running
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "Stopping existing container..."
    docker rm -f "$CONTAINER_NAME" >/dev/null
fi

# Prompt for account credentials
echo "=== Moomoo OpenD Login ==="
read -rp "Phone number (e.g. +8613800138000): " ACCOUNT_ID
read -rsp "Password: " ACCOUNT_PWD
echo ""

# Compute MD5 of password
ACCOUNT_PWD_MD5=$(echo -n "$ACCOUNT_PWD" | md5sum | awk '{print $1}')
unset ACCOUNT_PWD

echo "Starting OpenD container..."
docker run -d \
    --name "$CONTAINER_NAME" \
    -e FUTU_LOGIN_ACCOUNT="$ACCOUNT_ID" \
    -e FUTU_LOGIN_PWD_MD5="$ACCOUNT_PWD_MD5" \
    -p 11111:11111 \
    -p 8000:8000 \
    ostai/futuopend:latest

echo ""
echo "OpenD started. Waiting for it to be ready..."
sleep 5
docker logs --tail 30 "$CONTAINER_NAME"

echo ""
echo "If you need to enter a verification code, connect to the WebSocket on port 8000."
echo "To view logs: docker logs -f $CONTAINER_NAME"
