# AGENTS.md

> Project map for AI agents. Keep this file up-to-date as the project evolves.

## Project Overview
Neovim plugin that provides regex-based file filtering for neo-tree. Users can filter files by filename or content using an input box with regex expressions.

## Tech Stack
- **Language:** Lua
- **Plugin Type:** Neovim external source plugin
- **Target:** neo-tree nvim plugin

## Project Structure
```
.
├── .ai-factory/           # AI Factory context
│   ├── DESCRIPTION.md     # Project specification
│   ├── ARCHITECTURE.md    # Architecture decisions
│   ├── PLAN.md            # Implementation plan (completed)
│   └── ROADMAP.md         # Milestones and status
├── .opencode/             # AI skills and configuration
├── lua/neo-tree-filter/   # Plugin source
│   ├── init.lua           # External source entry point
│   ├── filter.lua         # rg-based filtering logic
│   ├── floating-input.lua # nui.input floating input
│   ├── commands.lua       # Neo-tree command handlers
│   └── components.lua     # Custom renderer components
├── readme.md              # Project documentation
└── TODO.md                # Project tasks
```

## Key Entry Points
| File | Purpose |
|------|---------|
| readme.md | Project goals and usage |
| lua/neo-tree-filter/init.lua | External source entry point |
| .ai-factory/DESCRIPTION.md | Project specification |

## Documentation
| Document | Path | Description |
|----------|------|-------------|
| README | readme.md | Project landing page |

## AI Context Files
| File | Purpose |
|------|---------|
| AGENTS.md | This file — project structure map |
| .ai-factory/DESCRIPTION.md | Project specification and tech stack |
| .ai-factory/ARCHITECTURE.md | Architecture decisions and guidelines |
| .ai-factory/ROADMAP.md | Milestones and status |
