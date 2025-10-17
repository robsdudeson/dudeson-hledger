#!/usr/bin/env bash
# Setup script to configure git hooks
# Run this after cloning the repository

set -e

echo "🔧 Setting up git hooks..."

# Configure git to use .githooks directory
git config core.hooksPath .githooks

# Make all hooks executable
chmod +x .githooks/*

echo "✅ Git hooks configured successfully!"
echo "   Hooks directory: .githooks/"
echo "   Active hooks:"
ls -1 .githooks/
