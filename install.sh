#!/usr/bin/env bash
set -euo pipefail

# Colors
GREEN='\033[32m'
RED='\033[31m'
YELLOW='\033[33m'
DIM='\033[2m'
RESET='\033[0m'

# Configuration
REPO="gulp/cc-toys"
VERSION="${VERSION:-main}"
DEST="${DEST:-$HOME/.local/bin}"
EXAMPLES_DEST="${EXAMPLES_DEST:-$HOME/.local/share/cc-toys/examples}"

echo -e "${GREEN}📦 Installing cc-toys${RESET}"
echo ""

# Check prerequisites
echo "Checking prerequisites..."

# Check jq
if ! command -v jq &> /dev/null; then
    echo -e "${RED}✗${RESET} jq is not installed"
    echo "  Install it first:"
    echo "    macOS:         brew install jq"
    echo "    Ubuntu/Debian: sudo apt install jq"
    echo "    Arch:          sudo pacman -S jq"
    exit 1
fi
echo -e "${GREEN}✓${RESET} jq installed"

# Check bash version
bash_version=$(bash --version | head -n1 | grep -oP '\d+\.\d+' | head -n1)
bash_major=$(echo "$bash_version" | cut -d. -f1)
if [ "$bash_major" -lt 4 ]; then
    echo -e "${RED}✗${RESET} Bash 4.0+ required (found $bash_version)"
    exit 1
fi
echo -e "${GREEN}✓${RESET} Bash $bash_version"

# Check Claude Code CLI
if ! command -v claude &> /dev/null; then
    echo -e "${YELLOW}⚠${RESET} Claude Code CLI not found"
    echo "  Install from: https://claude.ai/download"
    echo "  (Installation will continue, but you'll need it to run the tools)"
    echo ""
else
    echo -e "${GREEN}✓${RESET} Claude Code CLI installed"
fi

echo ""

# Create temp directory
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# Create destination if it doesn't exist
mkdir -p "$DEST"

echo "Installing scripts to $DEST..."

# Download ccup
if [ "$VERSION" = "main" ] || [ "$VERSION" = "latest" ]; then
    # Download from main branch
    curl -fsSL "https://raw.githubusercontent.com/$REPO/main/scripts/ccup" \
        -o "$TMP/ccup" || {
        echo -e "${RED}✗${RESET} Failed to download ccup"
        exit 1
    }

    curl -fsSL "https://raw.githubusercontent.com/$REPO/main/scripts/agentenv" \
        -o "$TMP/agentenv" || {
        echo -e "${RED}✗${RESET} Failed to download agentenv"
        exit 1
    }
else
    # Download from specific tag/version
    curl -fsSL "https://raw.githubusercontent.com/$REPO/$VERSION/scripts/ccup" \
        -o "$TMP/ccup" || {
        echo -e "${RED}✗${RESET} Failed to download ccup (version: $VERSION)"
        exit 1
    }

    curl -fsSL "https://raw.githubusercontent.com/$REPO/$VERSION/scripts/agentenv" \
        -o "$TMP/agentenv" || {
        echo -e "${RED}✗${RESET} Failed to download agentenv (version: $VERSION)"
        exit 1
    }
fi

# Make executable and install
chmod +x "$TMP/ccup" "$TMP/agentenv"
cp "$TMP/ccup" "$DEST/ccup"
cp "$TMP/agentenv" "$DEST/agentenv"

echo -e "${GREEN}✓${RESET} Installed ccup to $DEST/ccup"
echo -e "${GREEN}✓${RESET} Installed agentenv to $DEST/agentenv"
echo ""

# Offer to create alias
echo "Setting up aliases..."

# Detect shell config file
SHELL_CONFIG=""
if [ -n "${BASH_VERSION:-}" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        SHELL_CONFIG="$HOME/.bashrc"
    elif [ -f "$HOME/.bash_profile" ]; then
        SHELL_CONFIG="$HOME/.bash_profile"
    fi
elif [ -n "${ZSH_VERSION:-}" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
fi

echo -e "${DIM}Optional: Add an alias to your shell config${RESET}"
echo "  echo \"alias ccup='ccup'\" >> ~/.bashrc"
echo "  (ccup works fine without an alias)"

echo ""

# Check if DEST is in PATH
if [[ ":$PATH:" != *":$DEST:"* ]]; then
    echo -e "${YELLOW}⚠${RESET} $DEST is not in your PATH"
    echo "  Add this to your shell config:"
    echo "    export PATH=\"$DEST:\$PATH\""
    echo ""
fi

# Offer to download examples
echo "Examples contain MCP profile templates and agent configs."
echo "Download examples to $EXAMPLES_DEST? [Y/n]"
read -r response

if [[ -z "$response" ]] || [[ "$response" =~ ^[Yy]$ ]]; then
    mkdir -p "$EXAMPLES_DEST"

    # Download examples directory structure
    echo "Downloading examples..."

    # Create directories
    mkdir -p "$EXAMPLES_DEST/mcp_profiles"
    mkdir -p "$EXAMPLES_DEST/agents.env"

    # Download MCP profile examples
    for profile in core full research ui; do
        curl -fsSL "https://raw.githubusercontent.com/$REPO/$VERSION/examples/mcp_profiles/${profile}.json" \
            -o "$EXAMPLES_DEST/mcp_profiles/${profile}.json" 2>/dev/null || true
    done

    # Download agent examples
    for agent in pong explainer therapist; do
        curl -fsSL "https://raw.githubusercontent.com/$REPO/$VERSION/examples/agents/${agent}.md" \
            -o "$EXAMPLES_DEST/agents.env/${agent}.md" 2>/dev/null || true
    done

    # Download agent config example
    curl -fsSL "https://raw.githubusercontent.com/$REPO/$VERSION/examples/agents_config.json" \
        -o "$EXAMPLES_DEST/agents.env/agents_config.json" 2>/dev/null || true

    # Download agents README
    curl -fsSL "https://raw.githubusercontent.com/$REPO/$VERSION/examples/agents/README.md" \
        -o "$EXAMPLES_DEST/agents.env/README.md" 2>/dev/null || true

    echo -e "${GREEN}✓${RESET} Examples saved to $EXAMPLES_DEST"
    echo "  Copy to your projects:"
    echo "    cp -r $EXAMPLES_DEST/mcp_profiles your-project/.claude/"
    echo "    cp -r $EXAMPLES_DEST/agents.env/* your-project/.claude/agents.env/"
    echo ""
fi

# Final instructions
echo -e "${GREEN}✅ Installation complete!${RESET}"
echo ""
echo "Quick start:"
echo "  1. Navigate to a Claude project:  cd your-project"
echo "  2. Launch Claude:                 ccup"
echo ""
echo "Other commands:"
echo "  ccup -a          Select from all projects"
echo "  ccup --scaffold  Copy MCP profiles and demo agents to project"
echo "  agentenv <name>  Switch agent profile"
echo ""
echo "Documentation:"
echo "  https://github.com/$REPO"
echo ""
echo -e "${DIM}Tip: Reload your shell or run 'source ~/.bashrc' to enable aliases${RESET}"
