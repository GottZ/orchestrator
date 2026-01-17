---
description: Execute a single task from todo.md with verification and structured JSON output
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Task
argument-hint: "[project path]"
context: fork
agent: project-runner
---

# Single Task Execution

You are executing a single task using the enhanced project-runner.

**Project path**: $ARGUMENTS

If no path provided, use current working directory.

The runner will:
1. Load ONLY the current phase's quirks (not entire CLAUDE.md)
2. Find first unchecked task respecting dependencies
3. Implement the task
4. Run verification command if specified
5. Update documentation (todo.md, CLAUDE.md quirks, proj.md)
6. Commit changes
7. Return structured JSON result

JSON result format:
```json
{
  "status": "success|failed|blocked|verification_failed",
  "task_id": "X.Y",
  "verification": { "ran": true, "passed": true },
  "quirks_added": [...],
  "new_tasks_added": [...],
  "commit_hash": "abc123"
}
```

Begin by reading project context.
