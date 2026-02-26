local M = {}

local floating_win = nil
local popup_bufnr = nil

local function create_floating_input(opts)
  opts = opts or {}
  local on_submit = opts.on_submit or function() end
  local on_close = opts.on_close or function() end
  local default_text = opts.default_text or ''

  local popup = require('nui.popup')
  local components = require('neo-tree.ui.components')
  local renderer = require('neo-tree.ui.renderer')

  popup_bufnr = vim.api.nvim_create_buf(false, true)
  vim.bo[popup_bufnr].filetype = 'neo-tree-filter-input'

  local width = 60
  local height = 1

  local popup = popup({
    position = '50%',
    size = { width = width, height = height },
    buf = popup_bufnr,
    relative = 'editor',
    anchor = 'NW',
    border = {
      style = 'rounded',
      highlight = 'FloatBorder',
    },
    win_options = {
      winblend = 0,
      winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
    },
  })

  vim.api.nvim_buf_set_lines(popup_bufnr, 0, -1, false, { 'Filter: ' .. default_text })

  vim.defer_fn(function()
    vim.api.nvim_buf_call(popup_bufnr, function()
      vim.cmd('normal! $')
    end)
  end, 10)

  local function submit(value)
    popup:unmount()
    popup_bufnr = nil
    floating_win = nil
    on_submit(value)
  end

  local function close()
    popup:unmount()
    popup_bufnr = nil
    floating_win = nil
    on_close()
  end

  popup:map('i', '<Enter>', function()
    local lines = vim.api.nvim_buf_get_lines(popup_bufnr, 0, -1, false)
    local text = lines[1] or ''
    local pattern = text:gsub('^Filter:%s*', '')
    submit(pattern)
  end, { noremap = true })

  popup:map('n', '<Enter>', function()
    local lines = vim.api.nvim_buf_get_lines(popup_bufnr, 0, -1, false)
    local text = lines[1] or ''
    local pattern = text:gsub('^Filter:%s*', '')
    submit(pattern)
  end, { noremap = true })

  popup:map('i', '<Esc>', function()
    close()
  end, { noremap = true })

  popup:map('n', '<Esc>', function()
    close()
  end, { noremap = true })

  popup:map('i', '<F12>', function()
    local lines = vim.api.nvim_buf_get_lines(popup_bufnr, 0, -1, false)
    local text = lines[1] or ''
    local pattern = text:gsub('^Filter:%s*', '')
    vim.cmd('echo "Content filter (F12) not yet implemented"')
  end, { noremap = true })

  popup:map('n', '<F12>', function()
    local lines = vim.api.nvim_buf_get_lines(popup_bufnr, 0, -1, false)
    local text = lines[1] or ''
    local pattern = text:gsub('^Filter:%s*', '')
    vim.cmd('echo "Content filter (F12) not yet implemented"')
  end, { noremap = true })

  popup:mount()

  floating_win = popup
  return popup
end

M.open = function(opts)
  if floating_win and floating_win.bufnr then
    vim.api.nvim_set_current_win(floating_win.winid)
    return
  end
  return create_floating_input(opts)
end

M.close = function()
  if floating_win then
    floating_win:unmount()
    floating_win = nil
    popup_bufnr = nil
  end
end

M.is_open = function()
  return floating_win ~= nil and floating_win.bufnr ~= nil
end

return M
