# Project Orchestrator - Development

This is the meta-project for improving the orchestrator system itself.

## Project Overview

A 3-agent system for Claude Code: planner, orchestrator, runner.

## Key Files

| File | Purpose |
|------|---------|
| `agents/project-planner.md` | Planning agent instructions |
| `agents/project-orchestrator.md` | Orchestration agent instructions |
| `agents/project-runner.md` | Task execution agent instructions |
| `commands/{plan,orchestrate,task}.md` | Slash command wrappers |
| `examples/mini-test/` | Working example project |

## Development Guidelines

When improving this system:

1. **Test changes** on mini-test or a new test project
2. **Maintain backwards compatibility** with existing project structures
3. **Update examples** when adding new features
4. **Document quirks** in this file

## Key Quirks Discovered

### Quirks: Agent System

1. **Custom agents aren't native subagent_types**: Agents in `~/.claude/agents/` are loaded as instructions for the general-purpose agent, not as native Task subagent_types. The slash commands work around this by using `context: fork` and `agent: [name]`.

2. **Background agents have permission issues**: Running agents with `run_in_background: true` causes Bash/Read permissions to be auto-denied. Use foreground execution for tasks needing these tools.

3. **Structured JSON exit**: Runners must end with a JSON block for reliable parsing. The "TODO PROCESSED" string was fragile.

### Quirks: Checkpoint System

4. **Phase transitions**: Moving between phases requires updating the checkpoint state, but the todo.md is the source of truth for which tasks are complete.

5. **Resume detection**: Check for `.project-state.json` existence to determine fresh start vs resume.

### Quirks: Dependency Resolution

6. **Circular dependencies**: The orchestrator should detect and report cycles rather than deadlocking.

7. **parallel_safe is advisory**: Currently tasks still run sequentially; parallel execution is a future enhancement.

## Improvement Ideas

- [ ] Add actual parallel execution for parallel_safe tasks
- [ ] Add rollback capability for failed tasks
- [ ] Add progress bar / ETA estimation
- [ ] Add task retry with backoff
- [ ] Add notification on completion (e.g., webhook)
- [ ] Add diff view for what changed during execution
