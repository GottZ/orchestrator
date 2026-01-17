---
description: Execute a project plan with checkpointing, dependency resolution, and verification. Resumes automatically if interrupted.
allowed-tools: Read, Write, Edit, Bash, Task, TodoWrite
argument-hint: "[project path]"
context: fork
agent: project-orchestrator
---

# Project Orchestration Session

You are orchestrating execution of a project plan using the enhanced project-orchestrator.

**Project path**: $ARGUMENTS

If no path provided, use current working directory.

The orchestrator will:
1. Check for `.project-state.json` to resume or start fresh
2. Build task dependency graph from todo.md
3. Execute tasks respecting depends_on order
4. Run verification commands after each task
5. Update checkpoint state continuously
6. Handle failures gracefully (log and continue)
7. Transition between phases automatically

Features:
- **Checkpoint/Resume**: Survives session interruptions
- **Dependency Resolution**: Respects depends_on, detects deadlocks
- **Verification**: Runs verify commands, handles failures
- **Phase Scoping**: Only loads relevant phase quirks

Begin by loading project state.
