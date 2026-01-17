# Project Orchestrator

A 3-agent system for Claude Code that plans, orchestrates, and executes projects with checkpointing, dependency resolution, and verification.

## Features

- **Structured Planning**: Interactive questioning + codebase research via sub-agents
- **Checkpoint/Resume**: Survives session interruptions with `.project-state.json`
- **Dependency Resolution**: `depends_on` fields ensure correct task ordering
- **Verification Hooks**: `verify:` commands validate each task completion
- **Phase-Scoped Quirks**: Context-efficient quirk management per phase
- **Structured Communication**: JSON results between orchestrator and runners

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                      /planner [description]                      │
│                               │                                  │
│                               ▼                                  │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │                    project-planner                          ││
│  │  • Asks scoping questions                                   ││
│  │  • Spawns Explore agents for research                       ││
│  │  • Generates CLAUDE.md, todo.md, proj.md, prompt.md         ││
│  └─────────────────────────────────────────────────────────────┘│
│                               │                                  │
│                               ▼                                  │
│                     /orchestrate [path]                          │
│                               │                                  │
│                               ▼                                  │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │                  project-orchestrator                        ││
│  │  • Loads/creates .project-state.json                        ││
│  │  • Builds dependency graph from todo.md                     ││
│  │  • Spawns project-runner for each task                      ││
│  │  • Runs verification commands                               ││
│  │  • Updates checkpoint after each task                       ││
│  └─────────────────────────────────────────────────────────────┘│
│                               │                                  │
│                    ┌──────────┼──────────┐                      │
│                    ▼          ▼          ▼                      │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                    project-runner (×N)                    │  │
│  │  • Loads phase-specific quirks only                      │  │
│  │  • Implements single task                                │  │
│  │  • Runs verification                                     │  │
│  │  • Updates docs, commits                                 │  │
│  │  • Returns structured JSON result                        │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

## Quick Start

```bash
# 1. Install (see INSTALL.md)
./install.sh

# 2. Plan a new project
/planner "Add caching layer to the API"

# 3. Execute the plan
/orchestrate /path/to/project

# 4. Resume if interrupted
/orchestrate /path/to/project  # Reads .project-state.json automatically
```

## Project Structure (Generated)

```
your-project/
├── CLAUDE.md              # Context + phase-scoped quirks
├── todo.md                # Enhanced tasks with deps/verify
├── proj.md                # Research and reference
├── prompt.md              # Manual runner starter
└── .project-state.json    # Checkpoint (auto-created)
```

## Enhanced todo.md Format

```markdown
- [ ] **2.1 Create handler**
  - Implement the proxy handler
  - depends_on: 1.1, 1.2
  - parallel_safe: true
  - verify: `curl -sf localhost:8080/health`
```

## Slash Commands

| Command | Purpose |
|---------|---------|
| `/planner [description]` | Start planning with questions + research |
| `/orchestrate [path]` | Execute with checkpointing |
| `/task [path]` | Run single task manually |

## License

MIT
