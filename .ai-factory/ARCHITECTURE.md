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
│       ├── init.lua           # Plugin entry point
│       ├── filter.lua         # Core filtering logic
│       ├── input.lua           # Input box handling
│       └── preview.lua         # Preview mode handling
├── plugin/
│   └── neo-tree-filter.lua    # Plugin autocmds (optional)
└── README.md                  # Documentation
```

## Dependency Rules
- Plugin entry point (init.lua) loads modules
- Core modules (filter, input, preview) can depend on each other
- No external dependencies except neo-tree API

## Layer/Module Communication
- `init.lua` initializes the external source and event handlers
- `filter.lua` implements regex matching for files
- `input.lua` manages the input box UI
- `preview.lua` handles preview mode switching

## Key Principles
1. **Lazy loading** - Only load when needed for performance
2. **Standard paths** - Use `lua/neo-tree-filter/` for module loading
3. **Neo-tree integration** - Follow neo-tree's external source API
4. **Idempotent** - Safe to reload with `:luafile`

## Code Examples

### Plugin Entry (lua/neo-tree-filter/init.lua)
```lua
local M = {}

function M.setup(opts)
  -- Register as neo-tree external source
  require('neo-tree').setup({
    sources = { 'neo-tree-filter' },
    default_component_configs = {
      -- ...
    }
  })
end

return M
```

### Filter Module (lua/neo-tree-filter/filter.lua)
```lua
local M = {}

function M.filter_by_filename(root, pattern)
  -- Returns list of files matching pattern
end

function M.filter_by_content(root, pattern)
  -- Searches file contents and returns matches
end

return M
```

### External Source Definition
```lua
-- Must implement neo-tree's external source interface
return {
  name = 'neo-tree-filter',
  get_items = function(state)
    -- Return filtered file items
  end,
  ...
}
```

## Anti-Patterns
- ❌ Don't create complex dependency injection for a simple plugin
- ❌ Don't use OOP patterns unless truly needed - Lua tables are sufficient
- ❌ Don't depend on many external plugins - keep it lightweight
