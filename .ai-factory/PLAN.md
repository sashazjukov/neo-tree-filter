# Plan: Input Box UI

**Fast Mode** | Created: 2026-02-26 | Status: **Completed**

## Settings

- Testing: No
- Logging: Standard (INFO level)
- Docs: No

## Tasks

- [x] **Create lua/neo-tree-filter/init.lua** — External source entry point (`name`, `display_name`, `navigate`, `setup`) with keymaps and events
- [x] **Create lua/neo-tree-filter/floating-input.lua** — Floating regex input using nui.input with history navigation
- [x] **Create lua/neo-tree-filter/filter.lua** — Regex filtering logic for filename (`rg --files` + `vim.regex`) and content (`rg -ic`) search
- [x] **Create lua/neo-tree-filter/commands.lua** — Neo-tree command handlers (open_filter, open_and_search, refresh, show_debug_info)
- [x] **Create lua/neo-tree-filter/components.lua** — Custom renderer components (devicons, name highlights)
- [x] **Register source with neo-tree** — Added to neo-tree `sources`; discovered via `require("neo-tree-filter")`

## Notes

This implementation provides:
- Custom floating input window via nui.input (not vim.ui.input)
- Enter key triggers filename filtering
- F12 key triggers content filtering with match counts
- Search history with Up/Down navigation
- Integration with neo-tree's external source API

The plugin structure follows standard neovim plugin conventions with lua/neo-tree-filter/ directory.
