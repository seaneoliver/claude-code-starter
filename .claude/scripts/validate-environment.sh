#!/usr/bin/env bash
# validate-environment.sh - Full environment validation for Claude Code
# Complementary to validate-config.cjs (run manually, not as a hook)
# Usage: bash validate-environment.sh [--json] [--quiet]

set -euo pipefail

# ─── Configuration ───────────────────────────────────────────────────────────

CLAUDE_DIR="${USERPROFILE:-$HOME}/.claude"
CLAUDE_DIR="${CLAUDE_DIR//\\//}"

SETTINGS_JSON="${CLAUDE_DIR}/settings.json"
SETTINGS_LOCAL="${CLAUDE_DIR}/settings.local.json"
SKILLS_DIR="${CLAUDE_DIR}/skills"

REQUIRED_TOOLS=("node")
OPTIONAL_TOOLS=("git" "gh" "qmd" "az" "jq")

OUTPUT_JSON=false
QUIET=false
for arg in "$@"; do
  case "$arg" in
    --json) OUTPUT_JSON=true ;;
    --quiet) QUIET=true ;;
  esac
done

# ─── Counters ────────────────────────────────────────────────────────────────

ERRORS=0
WARNINGS=0
CHECKS=0

log_error() {
  ERRORS=$((ERRORS + 1))
  if [ "$QUIET" = false ] && [ "$OUTPUT_JSON" = false ]; then
    echo "  [ERROR] $1: $2"
  fi
}

log_warn() {
  WARNINGS=$((WARNINGS + 1))
  if [ "$QUIET" = false ] && [ "$OUTPUT_JSON" = false ]; then
    echo "  [WARN]  $1: $2"
  fi
}

log_ok() {
  CHECKS=$((CHECKS + 1))
  if [ "$QUIET" = false ] && [ "$OUTPUT_JSON" = false ]; then
    echo "  [OK]    $1"
  fi
}

section() {
  CHECKS=$((CHECKS + 1))
  if [ "$QUIET" = false ] && [ "$OUTPUT_JSON" = false ]; then
    echo ""
    echo "--- $1 ---"
  fi
}

# ─── 1. JSON Config Validation ──────────────────────────────────────────────

validate_json_file() {
  local file="$1"
  local label="$2"

  if [ ! -f "$file" ]; then
    log_warn "$label" "File not found: $file"
    return
  fi

  local result
  result=$(node -e "
    const fs = require('fs');
    try {
      const raw = fs.readFileSync(process.argv[1], 'utf8');
      const issues = [];
      if (/,\s*[}\]]/.test(raw)) { issues.push('trailing-comma'); }
      JSON.parse(raw);
      console.log(issues.length ? 'WARN:' + issues.join(',') : 'OK');
    } catch (e) {
      console.log('ERROR:' + e.message.split('\\n')[0]);
    }
  " "$file" 2>&1)

  if [[ "$result" == OK ]]; then
    log_ok "$label is valid JSON"
  elif [[ "$result" == WARN:* ]]; then
    log_warn "$label" "Parsed OK but has issues: ${result#WARN:}"
  elif [[ "$result" == ERROR:* ]]; then
    log_error "$label" "Invalid JSON: ${result#ERROR:}"
  fi
}

section "JSON Configuration Files"
validate_json_file "$SETTINGS_JSON" "settings.json"
validate_json_file "$SETTINGS_LOCAL" "settings.local.json"

# ─── 2. Skills Frontmatter Validation ───────────────────────────────────────

section "Skills Validation"

if [ ! -d "$SKILLS_DIR" ]; then
  log_warn "skills" "Skills directory not found: $SKILLS_DIR"
else
  skill_count=0
  skill_errors=0

  while IFS= read -r skill_file; do
    skill_count=$((skill_count + 1))
    skill_name=$(basename "$(dirname "$skill_file")")
    first_line=$(head -1 "$skill_file" 2>/dev/null | tr -d '\r')

    if [[ "$first_line" != "---" ]]; then
      log_error "skill:$skill_name" "Missing YAML frontmatter"
      skill_errors=$((skill_errors + 1))
      continue
    fi

    closing=$(tail -n +2 "$skill_file" | grep -n "^---" | head -1)
    if [ -z "$closing" ]; then
      log_error "skill:$skill_name" "Frontmatter never closed"
      skill_errors=$((skill_errors + 1))
      continue
    fi

    if head -20 "$skill_file" | grep -q "^name:"; then
      log_ok "skill:$skill_name"
    else
      log_error "skill:$skill_name" "Frontmatter missing 'name' field"
      skill_errors=$((skill_errors + 1))
    fi
  done < <(find "$SKILLS_DIR" -name "SKILL.md" -type f 2>/dev/null)

  if [ $skill_count -eq 0 ]; then
    log_warn "skills" "No skills found"
  else
    log_ok "Scanned $skill_count skills ($skill_errors errors)"
  fi
fi

# ─── 3. Tool Availability ────────────────────────────────────────────────────

section "Tool Availability"

for tool in "${REQUIRED_TOOLS[@]}"; do
  if command -v "$tool" &>/dev/null; then
    tool_ver=$("$tool" --version 2>/dev/null | head -1 || echo "unknown")
    log_ok "$tool (required) - $tool_ver"
  else
    log_error "PATH" "Required tool not found: $tool"
  fi
done

for tool in "${OPTIONAL_TOOLS[@]}"; do
  if command -v "$tool" &>/dev/null; then
    log_ok "$tool (optional) - available"
  else
    log_warn "PATH" "Optional tool not in PATH: $tool"
  fi
done

# ─── Summary ─────────────────────────────────────────────────────────────────

echo ""
echo "==========================================="
if [ $ERRORS -gt 0 ]; then
  echo "  RESULT: FAIL ($ERRORS errors, $WARNINGS warnings)"
elif [ $WARNINGS -gt 0 ]; then
  echo "  RESULT: PASS with warnings ($WARNINGS warnings)"
else
  echo "  RESULT: ALL CLEAR ($CHECKS checks passed)"
fi
echo "==========================================="

exit $ERRORS
