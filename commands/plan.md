---
description: Plan a new project with structured questions, codebase research, and dependency-aware task generation
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Task, AskUserQuestion
argument-hint: "[project description or path]"
context: fork
agent: project-planner
---

# Project Planning Session

You are starting a new project planning session using the enhanced project-planner.

**User's input**: $ARGUMENTS

The planner will:
1. Ask scoping questions (type, location, constraints)
2. Spawn Explore sub-agents to research the codebase
3. Ask detailed questions based on findings
4. Generate enhanced documentation:
   - `CLAUDE.md` with phase-scoped quirks sections
   - `todo.md` with depends_on, parallel_safe, verify fields
   - `proj.md` with research findings
   - `prompt.md` for manual runner invocation

Begin by understanding what the user wants to build.
