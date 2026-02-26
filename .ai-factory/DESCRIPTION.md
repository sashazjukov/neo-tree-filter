# Project: neo-tree-filter

## Overview
Neovim plugin that provides regex-based file filtering for neo-tree. Users can filter files by filename or content using an input box with regex expressions.

## Core Features
- Input box for entering regex expressions
- Filter by filename on Enter key press
- Filter by file content on F12 key press
- Display filtered results in neo-tree
- Switch neo-tree to preview mode

## Tech Stack
- **Language:** Lua
- **Plugin Type:** Neovim external source plugin
- **Target:** neo-tree nvim plugin

## Architecture Notes
- Standard neovim plugin structure (init.lua, etc.)
- Integrates with neo-tree's external sources API
- Uses nvim's input/dialog APIs for user interaction

## Architecture
See `.ai-factory/ARCHITECTURE.md` for detailed architecture guidelines.
Pattern: Standard Neovim Plugin (Layered)

## Non-Functional Requirements
- Regex filtering should be performant for large directories
- Must integrate seamlessly with neo-tree UI
