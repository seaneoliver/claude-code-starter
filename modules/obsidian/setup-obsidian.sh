#!/usr/bin/env bash
# setup-obsidian.sh — Obsidian vault integration for claude-code-starter
# Run after setup.sh, or standalone with --vault flag
# Usage: ./modules/obsidian/setup-obsidian.sh --vault /path/to/vault

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAULT_PATH=""
YOUR_NAME=""
YOUR_ROLE=""
YOUR_TEAM=""

# Parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    --vault) VAULT_PATH="$2"; shift 2 ;;
    --name) YOUR_NAME="$2"; shift 2 ;;
    --role) YOUR_ROLE="$2"; shift 2 ;;
    --team) YOUR_TEAM="$2"; shift 2 ;;
    *) shift ;;
  esac
done

# Prompt if not provided
if [ -z "$VAULT_PATH" ]; then
  read -rp "  Obsidian vault path: " VAULT_PATH
fi
if [ -z "$YOUR_NAME" ]; then
  read -rp "  Your name: " YOUR_NAME
fi

if [ ! -d "$VAULT_PATH" ]; then
  echo -e "${RED}Error: Vault not found at: $VAULT_PATH${NC}"
  exit 1
fi

echo ""
echo -e "${YELLOW}Installing Obsidian templates...${NC}"
echo ""

# Install templates
TEMPLATES_DIR="${VAULT_PATH}/Templates"
mkdir -p "$TEMPLATES_DIR"

for template in "${SCRIPT_DIR}/templates/"*.md; do
  fname=$(basename "$template")
  dest="${TEMPLATES_DIR}/${fname}"
  sed \
    -e "s/{{YOUR_NAME}}/${YOUR_NAME}/g" \
    -e "s/{{YOUR_ROLE}}/${YOUR_ROLE}/g" \
    -e "s/{{YOUR_TEAM}}/${YOUR_TEAM}/g" \
    "$template" > "$dest"
  echo -e "  ${GREEN}Installed:${NC} ${dest}"
done

echo ""
echo -e "${GREEN}Obsidian module installed.${NC}"
echo ""
echo "Next steps:"
echo "  - Enable Templater plugin in Obsidian"
echo "  - Set Templates folder to: Templates/"
echo "  - Optional: See docs/qmd-mcp-setup.md for vault search via Claude Code"
echo ""
