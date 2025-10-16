#!/usr/bin/env bash

# Example script showing different ways to use .env files in bash

set -e

echo "=== Method 1: Using the load-env helper ==="
# Source the load-env helper
if [ -f bin/load-env ]; then
    source bin/load-env .env
    echo "Environment loaded via helper script"
fi

echo ""
echo "=== Method 2: Simple inline loading ==="
# Quick one-liner to load .env (simple approach)
# Note: This doesn't handle comments or quoted values well
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
    echo "Environment loaded via simple export"
fi

echo ""
echo "=== Method 3: Using set -a (allexport) ==="
# This automatically exports all variables
if [ -f .env ]; then
    set -a  # Enable allexport mode
    source .env
    set +a  # Disable allexport mode
    echo "Environment loaded via set -a"
fi

echo ""
echo "=== Method 4: Inline at script execution ==="
# You can also load env vars inline when running a script:
# env $(cat .env | grep -v '^#' | xargs) your-script.sh

echo ""
echo "=== Accessing environment variables ==="
echo "PROJECT_ROOT=${PROJECT_ROOT:-not set}"
echo "DEFAULT_ACCOUNT=${DEFAULT_ACCOUNT:-not set}"
echo "AUTO_CATEGORIZE=${AUTO_CATEGORIZE:-not set}"

echo ""
echo "=== Best Practice: Use the load-env helper ==="
echo "It's safer and handles edge cases better!"
