# Project: neo-tree-filter

## Overview
Neovim plugin that adds a regex-based file filtering source to neo-tree. Users can filter files by filename or content using a floating input box with regex expressions, and browse the results as a tree.

## Core Features
- Floating input box (nui.input) for entering regex expressions, with Up/Down history navigation
- Filter by filename on Enter key press — `rg --files` + `vim.regex` match on file name (case-insensitive)
- Filter by file content on F12 key press — `rg -ic` search with per-file match count display
- Display filtered results in neo-tree as an external source, built into a directory tree
- Multiple stacked filters — each submission becomes its own removable tree node
- Word / visual selection filtering (`<F12>ff`) and clear keymaps (`<F12>fca` / `<F12>fcc`)
- Custom renderer components — devicons, highlighted filter term and match counts
- File open search — content results open the file and jump to the first match (rg regex converted to vim regex)

## Tech Stack
- **Language:** Lua
- **Plugin Type:** Neovim external source plugin
- **Target:** neo-tree nvim plugin
- **Dependencies:** neo-tree.nvim, nui.nvim, `rg` (ripgrep) binary; optional nvim-web-devicons

## Architecture Notes
- Standard neovim plugin structure (lua/neo-tree-filter/ directory)
- Integrates with neo-tree's external source API (`name`, `display_name`, `navigate`, `setup`)
- Uses nui.input for the floating input UI and `rg` for file/content search

## Architecture
See `.ai-factory/ARCHITECTURE.md` for detailed architecture guidelines.
Pattern: Standard Neovim Plugin (Layered)

## Non-Functional Requirements
- Regex filtering should be performant for large directories (delegated to ripgrep)
- Must integrate seamlessly with neo-tree UI
