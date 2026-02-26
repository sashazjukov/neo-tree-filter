local M = {}

M.setup = function(opts)
  -- Just setup the source, don't call neo-tree.setup()
  -- The source will be loaded via neo-tree's sources list
end

M.filter_by_filename = function(root, pattern)
  return require('neo-tree-filter.filter').filter_by_filename(root, pattern)
end

M.filter_by_content = function(root, pattern)
  return require('neo-tree-filter.filter').filter_by_content(root, pattern)
end

return M
