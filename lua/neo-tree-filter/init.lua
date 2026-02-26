local M = {}

M.setup = function(opts)
end

M.filter_by_filename = function(root, pattern)
  return require('neo-tree-filter.filter').filter_by_filename(root, pattern)
end

M.filter_by_content = function(root, pattern)
  return require('neo-tree-filter.filter').filter_by_content(root, pattern)
end

return M
