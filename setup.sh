#!/usr/bin/env bash
# setup.sh — claude-code-starter interactive setup
# Creates personalized Claude Code config from templates
# Usage: ./setup.sh

set -euo pipefail

# ─── Colors ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

CLAUDE_DIR="${HOME}/.claude"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TODAY=$(date +%Y-%m-%d)

echo ""
echo -e "${BLUE}=====================================================${NC}"
echo -e "${BLUE}  claude-code-starter — Interactive Setup${NC}"
echo -e "${BLUE}=====================================================${NC}"
echo ""
echo "This script will:"
echo "  1. Prompt for your personal details"
echo "  2. Generate config files from templates"
echo "  3. Install to ~/.claude/"
echo "  4. Optionally set up Obsidian vault integration"
echo ""

# ─── Prompt helpers ──────────────────────────────────────────────────────────

prompt() {
  local var_name="$1"
  local prompt_text="$2"
  local default_val="${3:-}"

  if [ -n "$default_val" ]; then
    read -rp "  ${prompt_text} [${default_val}]: " input
    input="${input:-$default_val}"
  else
    read -rp "  ${prompt_text}: " input
    while [ -z "$input" ]; do
      echo -e "  ${RED}Required. Please enter a value.${NC}"
      read -rp "  ${prompt_text}: " input
    done
  fi

  eval "$var_name=\"$input\""
}

# ─── Collect personal info ───────────────────────────────────────────────────

echo -e "${YELLOW}Step 1: Personal Details${NC}"
echo ""

prompt YOUR_NAME "Your full name (e.g., Alex Chen)"
prompt YOUR_ROLE "Your role/title (e.g., Senior Software Engineer)"
prompt YOUR_COMPANY "Your company or organization (e.g., Acme Corp)" "My Company"
prompt YOUR_TEAM "Your team/org name (e.g., Platform Engineering)"
prompt YOUR_LEVEL "Your level or seniority (e.g., Senior, IC4, L5, Staff)" "Senior"
prompt YOUR_NEXT_LEVEL "Your target next level (e.g., Staff, IC5, Principal)" "Staff"
prompt YOUR_MANAGER "Your manager's first name (e.g., Sam)" "My Manager"
prompt PLATFORM_NOTES "Platform notes (e.g., 'Mac environment' or 'Windows — use PowerShell-compatible commands')" "Mac environment"

echo ""
echo -e "${YELLOW}Step 2: Writing Voice${NC}"
echo ""
echo "  Describe your writing voice in 2-3 sentences."
echo "  Example: 'Direct and concise. Short sentences, no hedging. Evidence-based.'"
echo ""
read -rp "  Your writing style: " WRITING_VOICE
WRITING_VOICE="${WRITING_VOICE:-Direct and concise. No hedging.}"

echo ""
echo -e "${YELLOW}Step 3: Optional Integrations${NC}"
echo ""

# Obsidian vault
read -rp "  Obsidian vault path (leave blank to skip): " VAULT_PATH

# WorkIQ
read -rp "  Include WorkIQ skill? Requires Microsoft 365. (y/N): " include_workiq
include_workiq="${include_workiq:-n}"

echo ""

# ─── Generate config files ───────────────────────────────────────────────────

echo -e "${YELLOW}Step 4: Generating config files...${NC}"
echo ""

# Function to replace placeholders in a template file
apply_template() {
  local src="$1"
  local dest="$2"

  mkdir -p "$(dirname "$dest")"
  sed \
    -e "s/{{YOUR_NAME}}/${YOUR_NAME}/g" \
    -e "s/{{YOUR_ROLE}}/${YOUR_ROLE}/g" \
    -e "s/{{YOUR_COMPANY}}/${YOUR_COMPANY}/g" \
    -e "s/{{YOUR_TEAM}}/${YOUR_TEAM}/g" \
    -e "s/{{YOUR_LEVEL}}/${YOUR_LEVEL}/g" \
    -e "s/{{YOUR_NEXT_LEVEL}}/${YOUR_NEXT_LEVEL}/g" \
    -e "s/{{YOUR_MANAGER}}/${YOUR_MANAGER}/g" \
    -e "s/{{PLATFORM_NOTES}}/${PLATFORM_NOTES}/g" \
    -e "s/{{WRITING_PHILOSOPHY}}/${WRITING_VOICE}/g" \
    -e "s/{{SETUP_DATE}}/${TODAY}/g" \
    "$src" > "$dest"

  echo -e "  ${GREEN}Created:${NC} $dest"
}

# Install CLAUDE.md template
apply_template \
  "${SCRIPT_DIR}/templates/claude/CLAUDE.md.template" \
  "${CLAUDE_DIR}/CLAUDE.md"

# Install settings.json (only if not already present)
if [ ! -f "${CLAUDE_DIR}/settings.json" ]; then
  cp "${SCRIPT_DIR}/templates/claude/settings.json.template" "${CLAUDE_DIR}/settings.json"
  echo -e "  ${GREEN}Created:${NC} ${CLAUDE_DIR}/settings.json"
else
  echo -e "  ${YELLOW}Skipped:${NC} ${CLAUDE_DIR}/settings.json (already exists)"
fi

# Install settings.local.json (only if not already present)
if [ ! -f "${CLAUDE_DIR}/settings.local.json" ]; then
  cp "${SCRIPT_DIR}/templates/claude/settings.local.json.template" "${CLAUDE_DIR}/settings.local.json"
  echo -e "  ${GREEN}Created:${NC} ${CLAUDE_DIR}/settings.local.json"
else
  echo -e "  ${YELLOW}Skipped:${NC} ${CLAUDE_DIR}/settings.local.json (already exists)"
fi

# ─── Copy .claude/ files ─────────────────────────────────────────────────────

echo ""
echo -e "${YELLOW}Step 5: Installing Claude config files...${NC}"
echo ""

# SOUL.md and AGENTS.md
for f in SOUL.md AGENTS.md; do
  if [ ! -f "${CLAUDE_DIR}/${f}" ]; then
    cp "${SCRIPT_DIR}/.claude/${f}" "${CLAUDE_DIR}/${f}"
    echo -e "  ${GREEN}Created:${NC} ${CLAUDE_DIR}/${f}"
  else
    echo -e "  ${YELLOW}Skipped:${NC} ${CLAUDE_DIR}/${f} (already exists)"
  fi
done

# rules/
mkdir -p "${CLAUDE_DIR}/rules"
for f in "${SCRIPT_DIR}/.claude/rules/"*.md; do
  fname=$(basename "$f")
  if [ ! -f "${CLAUDE_DIR}/rules/${fname}" ]; then
    cp "$f" "${CLAUDE_DIR}/rules/${fname}"
    echo -e "  ${GREEN}Created:${NC} ${CLAUDE_DIR}/rules/${fname}"
  fi
done

# hooks/
mkdir -p "${CLAUDE_DIR}/hooks"
for f in "${SCRIPT_DIR}/.claude/hooks/"*.sh; do
  fname=$(basename "$f")
  cp "$f" "${CLAUDE_DIR}/hooks/${fname}"
  chmod +x "${CLAUDE_DIR}/hooks/${fname}"
  echo -e "  ${GREEN}Installed:${NC} ${CLAUDE_DIR}/hooks/${fname}"
done

# scripts/
mkdir -p "${CLAUDE_DIR}/scripts"
for f in "${SCRIPT_DIR}/.claude/scripts/"*; do
  fname=$(basename "$f")
  cp "$f" "${CLAUDE_DIR}/scripts/${fname}"
  echo -e "  ${GREEN}Installed:${NC} ${CLAUDE_DIR}/scripts/${fname}"
done

# skills/
mkdir -p "${CLAUDE_DIR}/skills"
for skill_dir in "${SCRIPT_DIR}/.claude/skills/"*/; do
  skill_name=$(basename "$skill_dir")
  # Skip workiq if user opted out
  if [ "$skill_name" = "workiq" ] && [[ "${include_workiq,,}" != "y"* ]]; then
    echo -e "  ${YELLOW}Skipped:${NC} skill: workiq (not selected)"
    continue
  fi
  # Copy full skill directory with template substitution for .md files
  while IFS= read -r -d '' src; do
    relative="${src#${skill_dir}}"
    dest="${CLAUDE_DIR}/skills/${skill_name}/${relative}"
    mkdir -p "$(dirname "$dest")"
    if [[ "$src" == *.md ]]; then
      apply_template "$src" "$dest"
    else
      cp "$src" "$dest"
    fi
  done < <(find "$skill_dir" -type f -print0)
  echo -e "  ${GREEN}Installed:${NC} skill: ${skill_name}"
done

# ─── Optional: Obsidian module ───────────────────────────────────────────────

if [ -n "$VAULT_PATH" ] && [ -d "$VAULT_PATH" ]; then
  echo ""
  echo -e "${YELLOW}Step 6: Obsidian module setup...${NC}"
  bash "${SCRIPT_DIR}/modules/obsidian/setup-obsidian.sh" \
    --vault "$VAULT_PATH" \
    --name "$YOUR_NAME" \
    --role "$YOUR_ROLE" \
    --team "$YOUR_TEAM"
elif [ -n "$VAULT_PATH" ]; then
  echo ""
  echo -e "  ${RED}Warning:${NC} Vault path not found: ${VAULT_PATH}"
  echo "  Skipping Obsidian module. Run modules/obsidian/setup-obsidian.sh manually."
fi

# ─── Done ────────────────────────────────────────────────────────────────────

echo ""
echo -e "${GREEN}=====================================================${NC}"
echo -e "${GREEN}  Setup complete!${NC}"
echo -e "${GREEN}=====================================================${NC}"
echo ""
echo "Next steps:"
echo "  1. Open a new Claude Code session to pick up the new config"
echo "  2. Personalize ~/.claude/CLAUDE.md with your specific rules"
echo "  3. Add your voice examples to templates/knowledge/voice-quick.md"
echo "  4. Run /learn to start adding learnings as you work"
echo ""
echo "Optional:"
echo "  - Run modules/obsidian/setup-obsidian.sh if you use Obsidian"
echo "  - See docs/mcp-integration.md to add your own MCP tools"
echo ""
