#!/bin/bash

# GitHub MCP Server Launch Script
# This script launches the GitHub MCP server

set -e

# Default values
PORT=${MCP_PORT:-3000}
GITHUB_TOKEN=${GITHUB_TOKEN:-}

# Check if GitHub token is provided
if [ -z "$GITHUB_TOKEN" ]; then
    echo "Error: GITHUB_TOKEN environment variable is required"
    echo "Please set your GitHub personal access token:"
    echo "export GITHUB_TOKEN=your_token_here"
    exit 1
fi

echo "Starting GitHub MCP server on port $PORT..."
echo "GitHub token: ${GITHUB_TOKEN:0:8}..." # Show only first 8 chars for security

# Launch the GitHub MCP server
# Note: Replace this command with the actual GitHub MCP server command
# This is a placeholder - you'll need to install and configure the actual GitHub MCP
npx @modelcontextprotocol/server-github \
    --port "$PORT" \
    --token "$GITHUB_TOKEN"