# TODO - neo-tree-filter

## Project Goals
- Input box for regex filtering
- Filter by filename (Enter)
- Filter by content (F12)
- Show results in neo-tree
- Preview mode

## Implementation

### Input Box UI
- [x] Create lua/neo-tree-filter/init.lua
- [x] Create lua/neo-tree-filter/floating-input.lua
- [x] Create lua/neo-tree-filter/filter.lua
- [x] Create lua/neo-tree-filter/source.lua

### Filename Filter
- [ ] Connect Enter key to filter_by_filename
- [ ] Test regex matching on filenames

### Content Filter
- [ ] Connect F12 key to filter_by_content
- [ ] Implement content search in filter.lua

### Neo-tree Integration
- [ ] Register as external source properly
- [ ] Display filtered results in neo-tree tree

### Preview Mode
- [ ] Switch neo-tree to preview mode when showing results
