# TODO - neo-tree-filter

## Completed

- [x] **Input Box UI** — Floating input via `nui.input` with history navigation (Up/Down)
- [x] **Filename Filter** — Enter key submits regex, matches via `vim.regex` on `rg --files` output
- [x] **Content Filter** — F12 key submits regex, searches via `rg -ic` with match count display
- [x] **Neo-tree External Source** — Registered and renders results with proper directory tree structure
- [x] **Keymaps** — `<F12>ff` (word/visual selection to filter), `<F12>fca` (clear all), `<F12>fcc` (clear node)
- [x] **Custom Components** — Devicon support, match count highlights, filter term highlighting
- [x] **File Open Search** — Opens matched file and jumps to first match on content filter results

## Remaining

### Preview Mode
- [ ] Switch neo-tree to preview mode when showing results
- [ ] Navigate between matched files without leaving neo-tree
- [ ] Auto-close preview when clearing filter

### Polish & Edge Cases
- [ ] Handle empty results gracefully (show "no matches" message)
- [ ] Validate regex before submitting (catch `vim.regex` errors in filename mode)
- [ ] Show filter mode (filename/content) indicator in the input prompt
- [ ] Add loading indicator for large directory content searches
- [ ] Persist filter state across neo-tree source switches

### Testing
- [ ] Test with special characters in filenames
- [ ] Test with large directories (100k+ files)
- [ ] Test content search with binary files
- [ ] Test on Windows (path separator handling)
