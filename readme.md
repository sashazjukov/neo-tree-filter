# neo-tree-filter

Neovim plugin that adds a **regex-based file filtering** source to [neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim). Filter files by **filename** or by **file content** from a floating input box, and browse the results as a tree.

![Type](https://img.shields.io/badge/type-plugin-informational.svg)

## Features

- **Filename filtering** — submit a regex (`Enter`) and get every file whose name matches, shown as a directory tree.
- **Content filtering** — submit a regex (`F12`) and get every file containing a match, with the per-file match count.
- **Multiple stacked filters** — run several filters; each becomes its own top-level node in the tree.
- **Word / visual selection filter** — start a search from the word under the cursor or from a visual selection (`<F12>ff`).
- **Search history** — `Up`/`Down` navigate previously used patterns in the input box.
- **Jump to match** — opening a content-filter result opens the file and jumps to the first match.
- **Custom rendering** — devicons, highlighted filter term and match counts.

## Requirements

- [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)
- [nui.nvim](https://github.com/MunifTanjim/nui.nvim) (floating input box)
- [`rg`](https://github.com/BurntSushi/ripgrep) (ripgrep) available in `$PATH`
- Optional: [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) for file icons

## Installation

Example with [lazy.nvim](https://github.com/folke/lazy.nvim). Point `dir` at your local checkout, or replace it with the repository spec below.

```lua
-- ~/.config/nvim/lua/plugins/neo-tree-filter.lua
return {
  dir = "/path/to/neo-tree-filter", -- or "sashazjukov/neo-tree-filter"
  dependencies = {
    "nvim-neo-tree/neo-tree.nvim",
    "MunifTanjim/nui.nvim",
  },
}
```

### Register the source with neo-tree

Add `"neo-tree-filter"` to neo-tree's `sources` list. neo-tree discovers the source by requiring the `neo-tree-filter` module, so no extra setup call is needed.

```lua
-- ~/.config/nvim/lua/plugins/neo-tree.lua
return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- optional but recommended
    "MunifTanjim/nui.nvim",
  },
  opts = {
    sources = { "filesystem", "buffers", "git_status", "neo-tree-filter" },
    source_selector = {
      sources = {
        { source = "filesystem" },
        { source = "buffers" },
        { source = "git_status" },
        { source = "neo-tree-filter", display_name = " Content Filter " },
      },
    },
  },
}
```

The `source_selector` entry is optional — it adds a tab labeled **Content Filter** to the neo-tree source selector.

> If `neo-tree-filter` does not appear, make sure the plugin is installed before neo-tree is set up and that `sources` contains exactly `"neo-tree-filter"`.

## Usage

Open the filter source with:

```vim
:Neotree neo-tree-filter
```

The first time you open it, a floating input box appears automatically. Type a regex and:

| Key      | Action                         |
|----------|--------------------------------|
| `Enter`  | Filter by **file name**        |
| `F12`    | Filter by **file content**     |
| `Up`     | Previous entry in history      |
| `Down`   | Next entry in history          |
| `Esc`    | Close the input box            |

After submitting, matching files are shown as a directory tree. The root node displays the filter mode and pattern, e.g. `f ( \.lua$ )` for filename or `c ( TODO )` for content. Content results append the match count next to each file name.

### In-tree keymaps

The plugin registers the following mappings while the `neo-tree-filter` source is focused:

| Keymap              | Action                                                        |
|---------------------|---------------------------------------------------------------|
| `f`                 | Open the filter input box again (add another filter)          |
| `<F12>ff` (normal)  | Filter by the word under the cursor                           |
| `<F12>ff` (visual)  | Filter by the visual selection                                |
| `<F12>fca`          | Clear **all** filter nodes                                    |
| `<F12>fcc`          | Clear the filter node under the cursor                        |
| `Enter` on a file   | Open the file (content results jump to the first match)       |

Note: the `<F12>...` mappings are set up for you when the source is initialized.

### Reference keymap from this setup

The author opens the source from their global keymaps (`~/.config/nvim/lua/config/keymaps.lua`):

```lua
vim.keymap.set("n", "<f12>fe", ":Neotree neo-tree-filter <CR>", { desc = "NeoTree Content Filter" })
```

## Example workflow

1. Press `<F12>fe` (or run `:Neotree neo-tree-filter`).
2. Filename example: type `\.lua$` and press `Enter` → all Lua files in the project are shown.
3. Content example: type `FixMe|HACK` and press `F12` → every file containing the pattern appears with match counts.
4. Press `Enter` on a result file to open it (content results land on the first match).
5. Press `<F12>fcc` on a filter node to drop that filter, or `<F12>fca` to clear everything.

## How it works

- **Filename mode** runs `rg --files <root>` and matches the file name against your pattern with `vim.regex` (case-insensitive).
- **Content mode** runs `rg -ic -- <pattern> <root>` and parses the match counts from its output.
- Results are assembled into a nested directory tree respecting the project root, directories expand automatically.
- Multiple submissions are kept as separate filter nodes in `state.filters`, so filters can be stacked and removed independently.

## Project structure

```
lua/neo-tree-filter/
├── init.lua           # External source entry point (navigate, keymaps, events)
├── filter.lua         # rg-based filename/content filtering + tree building
├── floating-input.lua # nui.input box with history and mode keybinds
├── commands.lua       # Neo-tree command handlers
└── components.lua     # Custom renderer components (icons, name highlights)
```

## License

MIT
