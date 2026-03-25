# setup.ps1 — claude-code-starter interactive setup (Windows PowerShell)
# Creates personalized Claude Code config from templates
# Usage: .\setup.ps1

$ErrorActionPreference = "Stop"

$ClaudeDir = "$env:USERPROFILE\.claude"
$ScriptDir = $PSScriptRoot
$Today = Get-Date -Format "yyyy-MM-dd"

Write-Host ""
Write-Host "=====================================================" -ForegroundColor Blue
Write-Host "  claude-code-starter — Interactive Setup" -ForegroundColor Blue
Write-Host "=====================================================" -ForegroundColor Blue
Write-Host ""
Write-Host "This script will:"
Write-Host "  1. Prompt for your personal details"
Write-Host "  2. Generate config files from templates"
Write-Host "  3. Install to ~\.claude\"
Write-Host "  4. Optionally set up Obsidian vault integration"
Write-Host ""

# ─── Prompt helpers ───────────────────────────────────────────────────────────

function Prompt-Required {
  param([string]$PromptText)
  do {
    $val = Read-Host "  $PromptText"
    if (-not $val) { Write-Host "  Required. Please enter a value." -ForegroundColor Red }
  } while (-not $val)
  return $val
}

function Prompt-Optional {
  param([string]$PromptText, [string]$Default = "")
  $val = Read-Host "  $PromptText [$Default]"
  if (-not $val) { $val = $Default }
  return $val
}

# ─── Collect personal info ────────────────────────────────────────────────────

Write-Host "Step 1: Personal Details" -ForegroundColor Yellow
Write-Host ""

$YourName      = Prompt-Required "Your full name (e.g., Alex Chen)"
$YourRole      = Prompt-Required "Your role/title (e.g., Senior Software Engineer)"
$YourCompany   = Prompt-Optional "Your company or organization (e.g., Acme Corp)" "My Company"
$YourTeam      = Prompt-Required "Your team/org name (e.g., Platform Engineering)"
$YourLevel     = Prompt-Optional "Your level or seniority (e.g., Senior, IC4, L5, Staff)" "Senior"
$YourNextLevel = Prompt-Optional "Your target next level (e.g., Staff, IC5, Principal)" "Staff"
$YourManager   = Prompt-Optional "Your manager's first name (e.g., Sam)" "My Manager"
$PlatformNotes = Prompt-Optional "Platform notes" "Windows environment. Use PowerShell-compatible commands."

Write-Host ""
Write-Host "Step 2: Writing Voice" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Describe your writing voice in 2-3 sentences."
Write-Host "  Example: 'Direct and concise. Short sentences, no hedging. Evidence-based.'"
Write-Host ""
$WritingVoice = Prompt-Optional "Your writing style" "Direct and concise. No hedging."

Write-Host ""
Write-Host "Step 3: Optional Integrations" -ForegroundColor Yellow
Write-Host ""

$VaultPath    = Read-Host "  Obsidian vault path (leave blank to skip)"
$IncludeWorkiq = Read-Host "  Include WorkIQ skill? Requires Microsoft 365. (y/N)"

Write-Host ""

# ─── Template substitution ────────────────────────────────────────────────────

Write-Host "Step 4: Generating config files..." -ForegroundColor Yellow
Write-Host ""

function Apply-Template {
  param([string]$Src, [string]$Dest)
  $dir = Split-Path $Dest -Parent
  if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }

  (Get-Content $Src -Raw) `
    -replace '\{\{YOUR_NAME\}\}',       $YourName `
    -replace '\{\{YOUR_ROLE\}\}',       $YourRole `
    -replace '\{\{YOUR_COMPANY\}\}',    $YourCompany `
    -replace '\{\{YOUR_TEAM\}\}',       $YourTeam `
    -replace '\{\{YOUR_LEVEL\}\}',      $YourLevel `
    -replace '\{\{YOUR_NEXT_LEVEL\}\}', $YourNextLevel `
    -replace '\{\{YOUR_MANAGER\}\}',    $YourManager `
    -replace '\{\{PLATFORM_NOTES\}\}',  $PlatformNotes `
    -replace '\{\{WRITING_PHILOSOPHY\}\}', $WritingVoice `
    -replace '\{\{SETUP_DATE\}\}',      $Today |
  Set-Content $Dest -Encoding UTF8

  Write-Host "  Created: $Dest" -ForegroundColor Green
}

# CLAUDE.md
Apply-Template `
  "$ScriptDir\templates\claude\CLAUDE.md.template" `
  "$ClaudeDir\CLAUDE.md"

# settings.json
if (-not (Test-Path "$ClaudeDir\settings.json")) {
  Copy-Item "$ScriptDir\templates\claude\settings.json.template" "$ClaudeDir\settings.json"
  Write-Host "  Created: $ClaudeDir\settings.json" -ForegroundColor Green
} else {
  Write-Host "  Skipped: $ClaudeDir\settings.json (already exists)" -ForegroundColor Yellow
}

# settings.local.json
if (-not (Test-Path "$ClaudeDir\settings.local.json")) {
  Copy-Item "$ScriptDir\templates\claude\settings.local.json.template" "$ClaudeDir\settings.local.json"
  Write-Host "  Created: $ClaudeDir\settings.local.json" -ForegroundColor Green
} else {
  Write-Host "  Skipped: $ClaudeDir\settings.local.json (already exists)" -ForegroundColor Yellow
}

# ─── Copy .claude/ files ──────────────────────────────────────────────────────

Write-Host ""
Write-Host "Step 5: Installing Claude config files..." -ForegroundColor Yellow
Write-Host ""

# SOUL.md and AGENTS.md
foreach ($f in @("SOUL.md", "AGENTS.md")) {
  $dest = "$ClaudeDir\$f"
  if (-not (Test-Path $dest)) {
    Copy-Item "$ScriptDir\.claude\$f" $dest
    Write-Host "  Created: $dest" -ForegroundColor Green
  } else {
    Write-Host "  Skipped: $dest (already exists)" -ForegroundColor Yellow
  }
}

# rules/
$rulesDir = "$ClaudeDir\rules"
if (-not (Test-Path $rulesDir)) { New-Item -ItemType Directory -Path $rulesDir -Force | Out-Null }
Get-ChildItem "$ScriptDir\.claude\rules\*.md" | ForEach-Object {
  $dest = "$rulesDir\$($_.Name)"
  if (-not (Test-Path $dest)) {
    Copy-Item $_.FullName $dest
    Write-Host "  Created: $dest" -ForegroundColor Green
  }
}

# hooks/
$hooksDir = "$ClaudeDir\hooks"
if (-not (Test-Path $hooksDir)) { New-Item -ItemType Directory -Path $hooksDir -Force | Out-Null }
Get-ChildItem "$ScriptDir\.claude\hooks\*" | ForEach-Object {
  Copy-Item $_.FullName "$hooksDir\$($_.Name)" -Force
  Write-Host "  Installed: $hooksDir\$($_.Name)" -ForegroundColor Green
}

# scripts/
$scriptsDir = "$ClaudeDir\scripts"
if (-not (Test-Path $scriptsDir)) { New-Item -ItemType Directory -Path $scriptsDir -Force | Out-Null }
Get-ChildItem "$ScriptDir\.claude\scripts\*" | ForEach-Object {
  Copy-Item $_.FullName "$scriptsDir\$($_.Name)" -Force
  Write-Host "  Installed: $scriptsDir\$($_.Name)" -ForegroundColor Green
}

# skills/ — copy full directory tree, apply template substitution to .md files
$skillsDir = "$ClaudeDir\skills"
if (-not (Test-Path $skillsDir)) { New-Item -ItemType Directory -Path $skillsDir -Force | Out-Null }
Get-ChildItem "$ScriptDir\.claude\skills" -Directory | ForEach-Object {
  $skillName = $_.Name
  # Skip workiq if not selected
  if ($skillName -eq "workiq" -and $IncludeWorkiq -notmatch "^[Yy]") {
    Write-Host "  Skipped: skill: workiq (not selected)" -ForegroundColor Yellow
    return
  }
  # Copy all files in the skill directory with template substitution for .md files
  $skillSrcRoot = $_.FullName
  Get-ChildItem $skillSrcRoot -Recurse -File | ForEach-Object {
    $srcFile = $_.FullName
    $relative = $srcFile.Substring($skillSrcRoot.Length + 1)
    $destFile = "$skillsDir\$skillName\$relative"
    $destDir = Split-Path $destFile -Parent
    if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }
    if ($srcFile -match '\.md$') {
      Apply-Template $srcFile $destFile
    } else {
      Copy-Item $srcFile $destFile -Force
    }
  }
  Write-Host "  Installed: skill: $skillName" -ForegroundColor Green
}

# ─── Optional: Obsidian module ────────────────────────────────────────────────

if ($VaultPath -and (Test-Path $VaultPath)) {
  Write-Host ""
  Write-Host "Step 6: Obsidian module setup..." -ForegroundColor Yellow
  & "$ScriptDir\modules\obsidian\setup-obsidian.ps1" `
    -VaultPath $VaultPath `
    -YourName $YourName `
    -YourRole $YourRole `
    -YourTeam $YourTeam
} elseif ($VaultPath) {
  Write-Host ""
  Write-Host "  Warning: Vault path not found: $VaultPath" -ForegroundColor Red
  Write-Host "  Skipping Obsidian module. Run modules\obsidian\setup-obsidian.ps1 manually."
}

# ─── Done ─────────────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "=====================================================" -ForegroundColor Green
Write-Host "  Setup complete!" -ForegroundColor Green
Write-Host "=====================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Open a new Claude Code session to pick up the new config"
Write-Host "  2. Personalize ~\.claude\CLAUDE.md with your specific rules"
Write-Host "  3. Add your voice examples to ~\.claude\skills\write-like-me\voice-guide.md"
Write-Host "  4. Run /learn to start adding learnings as you work"
Write-Host ""
Write-Host "Optional:"
Write-Host "  - Run modules\obsidian\setup-obsidian.ps1 if you use Obsidian"
Write-Host "  - See docs\mcp-integration.md to add your own MCP tools"
Write-Host ""
