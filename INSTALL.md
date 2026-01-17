# Installation

## Prerequisites

- [Claude Code CLI](https://claude.ai/claude-code) installed
- Git (for version control of your projects)

## Quick Install

```bash
# Clone or download this repository
cd ~/dev/orchestrator

# Run the install script
./install.sh
```

## Manual Install

### Option 1: Symlinks (Recommended)

Symlinks allow updates to propagate automatically:

```bash
# Create directories if they don't exist
mkdir -p ~/.claude/agents ~/.claude/commands

# Symlink agents
ln -sf ~/dev/orchestrator/agents/project-planner.md ~/.claude/agents/
ln -sf ~/dev/orchestrator/agents/project-orchestrator.md ~/.claude/agents/
ln -sf ~/dev/orchestrator/agents/project-runner.md ~/.claude/agents/

# Symlink commands
ln -sf ~/dev/orchestrator/commands/plan.md ~/.claude/commands/
ln -sf ~/dev/orchestrator/commands/orchestrate.md ~/.claude/commands/
ln -sf ~/dev/orchestrator/commands/task.md ~/.claude/commands/
```

### Option 2: Copy Files

If you prefer standalone copies:

```bash
# Create directories
mkdir -p ~/.claude/agents ~/.claude/commands

# Copy agents
cp ~/dev/orchestrator/agents/*.md ~/.claude/agents/

# Copy commands
cp ~/dev/orchestrator/commands/*.md ~/.claude/commands/
```

## Verify Installation

Start a new Claude Code session and check:

```bash
# Should show plan, orchestrate, task in available commands
/help

# Test the planner
/plan "Test project"
```

## Uninstall

```bash
# Remove symlinks or files
rm ~/.claude/agents/project-*.md
rm ~/.claude/commands/{plan,orchestrate,task}.md
```

## Updating

If using symlinks:
```bash
cd ~/dev/orchestrator
git pull
```

If using copies:
```bash
cd ~/dev/orchestrator
git pull
cp agents/*.md ~/.claude/agents/
cp commands/*.md ~/.claude/commands/
```

## Troubleshooting

### Commands not appearing

1. Ensure files are in the correct location
2. Start a new Claude Code session
3. Check file permissions: `ls -la ~/.claude/commands/`

### Agent not found errors

Custom agents defined in `~/.claude/agents/` are loaded as instructions for the general-purpose agent, not as native subagent_types. This is a Claude Code limitation. The slash commands handle this automatically.

### Permission denied errors

Ensure the Claude Code CLI has permission to read the agent/command files:
```bash
chmod 644 ~/.claude/agents/*.md
chmod 644 ~/.claude/commands/*.md
```
