local M = {}

M.open = function(opts)
  opts = opts or {}
  local on_submit = opts.on_submit or function() end
  local on_close = opts.on_close or function() end
  local default_text = opts.default_text or ''

  local inputs = require('neo-tree.ui.inputs')
  inputs.input('Filter: ', default_text, function(value)
    if value and value ~= '' then
      on_submit(value)
    else
      on_close()
    end
  end, nil, nil)
end

M.close = function()
end

M.is_open = function()
  return false
end

return M
