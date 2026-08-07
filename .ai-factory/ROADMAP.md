# Project Roadmap

> Neovim plugin that provides regex-based file filtering for neo-tree with a floating input box

## Milestones

### Completed

- [x] **Input Box UI** — Floating input (nui.input) for regex expressions with Up/Down history
- [x] **Filename Filter** — Filter files by regex matching filename on Enter key (`rg --files` + `vim.regex`)
- [x] **Content Filter** — Filter files by regex matching file content on F12 key (`rg -ic` with match counts)
- [x] **Neo-tree Integration** — Display filtered results as an external source with directory tree
- [x] **Multiple Stacked Filters** — Each submission becomes its own removable tree node
- [x] **Word/Visual Selection Filtering** — `<F12>ff` starts search from word or selection
- [x] **Custom Components** — Devicons, filter term and match count highlighting
- [x] **File Open Search** — Content results open file and jump to first match

### Remaining

- [ ] **Preview Mode** — Switch neo-tree to preview mode for results, navigate between matched files, auto-close on clear
- [ ] **Polish & Edge Cases** — Empty-results message, regex validation before submit, filter-mode indicator, loading indicator, persist filter state across source switches
- [ ] **Testing** — Special characters in filenames, large directories (100k+ files), binary content search, Windows path handling

## Completed

| Milestone | Date |
|-----------|------|
| Input Box UI | 2026-02-26 |
| Filename Filter | 2026-02-26 |
| Content Filter | 2026-02-26 |
| Neo-tree Integration | 2026-02-26 |
| Keymaps + Components + Open Search | 2026-02-26 |
