local M = {}

local state = {
  cwd = vim.fn.getcwd(),
  filter_pattern = '',
  filter_type = 'filename',
}

M.setup = function(opts)
  state.cwd = opts.cwd or vim.fn.getcwd()
end

M.get_state = function()
  return state
end

M.get_items = function(state_obj)
  state_obj = state_obj or state

  if state_obj.filter_pattern == '' then
    return {
      {
        id = 'placeholder',
        name = 'No filter - type a regex pattern',
        type = 'message',
      },
    }, { needs_refresh = false }
  end

  local root = state_obj.cwd
  local pattern = state_obj.filter_pattern

  if state_obj.filter_type == 'filename' then
    local filter = require('neo-tree-filter.filter')
    local results = filter.filter_by_filename(root, pattern)
    return results, { needs_refresh = false }
  else
    local filter = require('neo-tree-filter.filter')
    local results = filter.filter_by_content(root, pattern)
    return results, { needs_refresh = false }
  end
end

M.navigate = function(state_obj)
  state_obj = state_obj or state
  return M.get_items(state_obj)
end

M.execute = function(state_obj, node)
  if node.type == 'file' then
    vim.cmd('edit ' .. node.path)
  end
end

M.refresh = function(state_obj)
  return M.get_items(state_obj)
end

M.show_in_filemanager = function(node)
  vim.fn['netrw#BrowseX'](node.path, 0)
end

M.get_name = function()
  return 'neo-tree-filter'
end

M.get_component_configs = function()
  return {}
end

M.filter_by_filename = function(pattern)
  state.filter_pattern = pattern
  state.filter_type = 'filename'
  require('neo-tree').refresh({ source = 'neo-tree-filter' })
end

M.filter_by_content = function(pattern)
  state.filter_pattern = pattern
  state.filter_type = 'content'
  require('neo-tree').refresh({ source = 'neo-tree-filter' })
end

return M
