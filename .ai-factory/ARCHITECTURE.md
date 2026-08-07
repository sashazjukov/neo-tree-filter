# Architecture: Standard Neovim Plugin

## Overview
Standard neovim plugin structure following lua/runtime conventions. This is the most common and recommended pattern for neovim plugins - simple, familiar to neovim users, and works well with plugin managers.

## Decision Rationale
- **Project type:** Neovim external source plugin
- **Tech stack:** Lua (neovim plugin)
- **Key factor:** Small project, single developer, standard neovim conventions

## Folder Structure
```
.
├── lua/
│   └── neo-tree-filter/
│       ├── init.lua           # External source entry point (navigate, keymaps, events)
│       ├── filter.lua         # rg-based filename/content filtering + tree building
│       ├── floating-input.lua # nui.input floating input with history navigation
│       ├── commands.lua       # Neo-tree command handlers
│       └── components.lua     # Custom renderer components (icons, name highlights)
├── readme.md                  # Documentation
└── TODO.md                    # Project tasks
```

## Dependency Rules
- Plugin entry point (init.lua) loads modules
- `filter.lua` and `floating-input.lua` are used by `init.lua`; they do not depend on each other
- External dependencies: neo-tree.nvim API, nui.nvim, `rg` binary (optional nvim-web-devicons)

## Layer/Module Communication
- `init.lua` defines the external source (`name`, `display_name`, `navigate`, `setup`) and wires keymaps/events
- `filter.lua` implements regex matching for files (`filter_by_filename`, `filter_by_content`) and builds the directory tree
- `floating-input.lua` manages the floating input box UI (nui.input) and submit callbacks
- `commands.lua` maps neo-tree source commands to source functions
- `components.lua` overrides renderer components with devicons and highlight support

## Key Principles
1. **Lazy loading** - Only load when needed for performance
2. **Standard paths** - Use `lua/neo-tree-filter/` for module loading
3. **Neo-tree integration** - Follow neo-tree's external source API
4. **Idempotent** - Safe to reload with `:luafile`

## Code Examples

### External Source Definition (lua/neo-tree-filter/init.lua)
```lua
local M = {
  name = "neo-tree-filter",
  display_name = " Content Filter ",
}

-- Called by neo-tree on source navigation
M.navigate = function(state, path)
  -- scan files, build items, render via renderer.show_nodes(items, state)
end

-- Called by neo-tree when the source is set up
M.setup = function(config, global_config)
  -- register keymaps, subscribe to events
end

return M
```

### Filter Module (lua/neo-tree-filter/filter.lua)
```lua
local M = {}

function M.filter_by_filename(root, pattern)
  -- rg --files <root>, match file names with vim.regex
end

function M.filter_by_content(root, pattern)
  -- rg -ic -- <pattern> <root>, parse match counts
end

return M
```

### Registration
Neo-tree discovers the source by `require("neo-tree-filter")` when the name is listed in neo-tree's `sources` config. No explicit registration call is required:

```lua
require("neo-tree").setup({
  sources = { "filesystem", "buffers", "git_status", "neo-tree-filter" },
})
```

## Anti-Patterns
- ❌ Don't create complex dependency injection for a simple plugin
- ❌ Don't use OOP patterns unless truly needed - Lua tables are sufficient
- ❌ Don't depend on many external plugins - keep it lightweight
