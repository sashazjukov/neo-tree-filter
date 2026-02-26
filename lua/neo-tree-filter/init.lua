local M = {}

M.setup = function(opts)
  opts = opts or {}

  local source = require('neo-tree-filter.source')

  require('neo-tree').setup({
    sources = {
      'neo-tree-filter',
    },
    default_component_configs = source.get_component_configs(),
  })

  vim.api.nvim_create_autocmd('BufWinEnter', {
    pattern = '*',
    callback = function(args)
      if vim.bo[args.buf].filetype == 'neo-tree-popup' then
        vim.keymap.set('n', '<Enter>', function()
          local popup = require('nui.popup')
          local event = require('nui.popup').events
        end, { buffer = args.buf })
      end
    end,
  })

  require('neo-tree-filter.source').setup(opts)
end

M.filter_by_filename = function(root, pattern)
  return require('neo-tree-filter.filter').filter_by_filename(root, pattern)
end

M.filter_by_content = function(root, pattern)
  return require('neo-tree-filter.filter').filter_by_content(root, pattern)
end

return M
