#!/usr/bin/env bash
set -euo pipefail

# Colors
GREEN='\033[32m'
RED='\033[31m'
YELLOW='\033[33m'
DIM='\033[2m'
RESET='\033[0m'

# Configuration
DEST="${DEST:-$HOME/.local/bin}"
EXAMPLES_DEST="${EXAMPLES_DEST:-$HOME/.local/share/cc-toys/examples}"

echo -e "${YELLOW}🗑️  Uninstalling cc-toys${RESET}"
echo ""

# Remove scripts
if [ -f "$DEST/ccup" ]; then
    rm "$DEST/ccup"
    echo -e "${GREEN}✓${RESET} Removed $DEST/ccup"
else
    echo -e "${DIM}  $DEST/ccup not found${RESET}"
fi

if [ -f "$DEST/agentenv" ]; then
    rm "$DEST/agentenv"
    echo -e "${GREEN}✓${RESET} Removed $DEST/agentenv"
else
    echo -e "${DIM}  $DEST/agentenv not found${RESET}"
fi

# Ask about examples
if [ -d "$EXAMPLES_DEST" ]; then
    echo ""
    echo "Remove examples directory ($EXAMPLES_DEST)? [y/N]"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        rm -rf "$EXAMPLES_DEST"
        echo -e "${GREEN}✓${RESET} Removed examples"
    fi
fi

# Note about config
echo ""
echo "Note: If you added any shell aliases, remove them manually from:"
echo "  ~/.bashrc or ~/.zshrc"

echo ""
echo -e "${GREEN}✅ Uninstall complete${RESET}"
