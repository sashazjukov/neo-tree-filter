local M = {}

M.open = function(opts)
  opts = opts or {}
  local on_submit = opts.on_submit or function() end
  local on_close = opts.on_close or function() end
  local default_text = opts.default_text or ''

  local input = require('neo-tree.ui.inputs')
  input(default_text, 'Filter: ', function(value)
    on_submit(value)
  end, function()
    on_close()
  end)
end

M.close = function()
end

M.is_open = function()
  return false
end

return M
