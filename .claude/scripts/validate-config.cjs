#!/usr/bin/env node
/**
 * validate-config.cjs - Quick config validation for Claude Code session-start hook
 * Runs fast checks and outputs a clean summary to stderr (shown to user)
 * Exit 0 always (hook should never block session start)
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const CLAUDE_DIR = path.join(process.env.USERPROFILE || process.env.HOME, '.claude');
const issues = [];
const warnings = [];

// ─── Helpers ────────────────────────────────────────────────────────────────

function checkJsonFile(filePath, label) {
  if (!fs.existsSync(filePath)) return;
  try {
    const raw = fs.readFileSync(filePath, 'utf8');

    // Check for trailing commas
    if (/,\s*[}\]]/.test(raw)) {
      warnings.push(`${label}: contains trailing comma(s) (may break strict parsers)`);
    }

    JSON.parse(raw);
  } catch (e) {
    issues.push(`${label}: Invalid JSON - ${e.message.split('\n')[0]}`);
  }
}

function checkSkillFrontmatter(skillFile, skillName) {
  try {
    const content = fs.readFileSync(skillFile, 'utf8');
    const lines = content.split('\n').map(l => l.replace(/\r$/, ''));

    if (lines[0] !== '---') {
      issues.push(`skill:${skillName}: Missing YAML frontmatter (no opening ---)`);
      return;
    }

    const closeIdx = lines.indexOf('---', 1);
    if (closeIdx === -1) {
      issues.push(`skill:${skillName}: Frontmatter never closed (no closing ---)`);
      return;
    }

    const fm = lines.slice(1, closeIdx).join('\n');
    if (!fm.includes('name:')) {
      issues.push(`skill:${skillName}: Frontmatter missing 'name' field`);
    }
    if (!fm.includes('description:')) {
      warnings.push(`skill:${skillName}: Frontmatter missing 'description' field`);
    }
  } catch (e) {
    warnings.push(`skill:${skillName}: Could not read file`);
  }
}

function checkHookFileRefs(configPath, configLabel) {
  if (!fs.existsSync(configPath)) return;
  try {
    const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
    const hooks = config.hooks || {};

    for (const [event, hookList] of Object.entries(hooks)) {
      if (!Array.isArray(hookList)) continue;
      for (const entry of hookList) {
        const innerHooks = entry.hooks || [];
        for (const h of innerHooks) {
          if (!h.command) continue;

          // Extract PowerShell -File references
          const psFileMatch = h.command.match(/-File\s+"([^"]+)"/);
          if (psFileMatch) {
            const refPath = psFileMatch[1].replace(/\$\{USERPROFILE\}/g, process.env.USERPROFILE || '');
            if (!fs.existsSync(refPath)) {
              issues.push(`hook:${configLabel}: File not found: ${path.basename(refPath)}`);
            }
          }

          // Extract node "path" references (skip inline -e scripts)
          const nodeFileMatch = h.command.match(/node\s+"([^"]+)"/);
          if (nodeFileMatch) {
            let refPath = nodeFileMatch[1];
            if (refPath.includes('${CLAUDE_PLUGIN_ROOT}')) continue;
            refPath = refPath.replace(/\$\{USERPROFILE\}/g, process.env.USERPROFILE || '');
            if (!fs.existsSync(refPath)) {
              issues.push(`hook:${configLabel}: File not found: ${path.basename(refPath)}`);
            }
          }
        }
      }
    }
  } catch (e) {
    // Config already checked for JSON validity above
  }
}

function checkToolInPath(tool) {
  try {
    execSync(`where ${tool}`, { stdio: 'pipe', timeout: 3000 });
    return true;
  } catch {
    try {
      execSync(`which ${tool}`, { stdio: 'pipe', timeout: 3000, shell: 'bash' });
      return true;
    } catch {
      return false;
    }
  }
}

// ─── Run Checks ─────────────────────────────────────────────────────────────

// 1. JSON configs
checkJsonFile(path.join(CLAUDE_DIR, 'settings.json'), 'settings.json');
checkJsonFile(path.join(CLAUDE_DIR, 'settings.local.json'), 'settings.local.json');

// 2. Skills frontmatter (directory-based)
const skillsDir = path.join(CLAUDE_DIR, 'skills');
if (fs.existsSync(skillsDir)) {
  const entries = fs.readdirSync(skillsDir, { withFileTypes: true });
  for (const entry of entries) {
    if (entry.isDirectory()) {
      const skillFile = path.join(skillsDir, entry.name, 'SKILL.md');
      if (fs.existsSync(skillFile)) {
        checkSkillFrontmatter(skillFile, entry.name);
      }
    } else if (entry.isFile() && entry.name.endsWith('.md')) {
      checkSkillFrontmatter(path.join(skillsDir, entry.name), entry.name.replace('.md', ''));
    }
  }
}

// 3. Hook file references
checkHookFileRefs(path.join(CLAUDE_DIR, 'settings.json'), 'settings.json');
checkHookFileRefs(path.join(CLAUDE_DIR, 'settings.local.json'), 'settings.local.json');

// 4. Critical tools
const missingRequired = [];
if (!checkToolInPath('node')) missingRequired.push('node');

const missingOptional = [];
for (const tool of ['git', 'gh']) {
  if (!checkToolInPath(tool)) missingOptional.push(tool);
}

if (missingRequired.length > 0) {
  issues.push(`PATH: Required tools missing: ${missingRequired.join(', ')}`);
}
if (missingOptional.length > 0) {
  warnings.push(`PATH: Optional tools not found: ${missingOptional.join(', ')} (may need new terminal)`);
}

// ─── Output ─────────────────────────────────────────────────────────────────

if (issues.length === 0 && warnings.length === 0) {
  process.stderr.write('[Config] All checks passed\n');
} else {
  process.stderr.write('\n[Config Validation]\n');

  if (issues.length > 0) {
    process.stderr.write(`  ERRORS (${issues.length}):\n`);
    for (const issue of issues) {
      process.stderr.write(`    * ${issue}\n`);
    }
  }

  if (warnings.length > 0) {
    process.stderr.write(`  WARNINGS (${warnings.length}):\n`);
    for (const w of warnings) {
      process.stderr.write(`    - ${w}\n`);
    }
  }

  if (issues.length > 0) {
    process.stderr.write(`  TIP: Run /learn to add the fix as a learned rule\n`);
  }
  process.stderr.write('\n');
}

// Always exit 0 so we don't block session start
process.exit(0);
