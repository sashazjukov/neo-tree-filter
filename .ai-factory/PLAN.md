# Plan: Input Box UI

**Fast Mode** | Created: 2026-02-26

## Settings

- Testing: No
- Logging: Standard (INFO level)
- Docs: No

## Tasks

- [x] **Create lua/neo-tree-filter/init.lua** — Plugin entry point with setup function and neo-tree integration
- [x] **Create lua/neo-tree-filter/floating-input.lua** — Custom floating window for regex input using nui.nvim
- [x] **Create lua/neo-tree-filter/filter.lua** — Regex filtering logic for filename and content search
- [x] **Create lua/neo-tree-filter/source.lua** — Neo-tree external source definition with state management

## Notes

This implementation provides:
- Custom floating input window (not vim.ui.input)
- Enter key triggers filename filtering
- F12 key placeholder for content filtering
- Integration with neo-tree's external source API

The plugin structure follows standard neovim plugin conventions with lua/neo-tree-filter/ directory.
