# neo-tree-filter

Neovim plugin that provides regex-based file filtering for neo-tree.

## Goal

- Provide an input box where user enters regex expression to filter files by filename or by content
- Press Enter to filter by filename
- Press F12 to filter by file content
- Results shown in neo-tree
- Switch to preview mode

## Setup

**Important:** You must add `"neo-tree-filter"` to your neo-tree sources in your config:

```lua
require('neo-tree').setup({
  sources = { "filesystem", "buffers", "git_status", "neo-tree-filter" },
})
```

## Usage

```vim
:NeoTree neo-tree-filter
```

Then enter a regex pattern in the input box:
- Press **Enter** to filter by filename
- Press **F12** to filter by file content
