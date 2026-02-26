local vim = vim
local renderer = require("neo-tree.ui.renderer")
local manager = require("neo-tree.sources.manager")
local events = require("neo-tree.events")
local utils = require("neo-tree.utils")

local M = {
  name = "neo-tree-filter",
  display_name = " Filter ",
}

local filter = require("neo-tree-filter.filter")
local floating_input = require("neo-tree-filter.floating-input")

local function refresh_source()
  manager.refresh("neo-tree-filter")
end

M.navigate = function(state, path)
  if path == nil then
    path = vim.fn.getcwd()
  end
  state.path = path

  local filter_pattern = state.filter_pattern or ""
  local filter_type = state.filter_type or "filename"

  local items

  if filter_pattern == "" then
    items = {
      {
        id = "placeholder",
        name = "Press Enter to type regex filter",
        type = "message",
      }
    }
    vim.defer_fn(function()
      M.open_filter_input(state)
    end, 100)
  elseif filter_type == "filename" then
    items = filter.filter_by_filename(path, filter_pattern)
  else
    items = filter.filter_by_content(path, filter_pattern)
  end

  renderer.show_nodes(items, state)
end

M.open_filter_input = function(state)
  floating_input.open({
    default_text = state.filter_pattern or "",
    on_submit = function(value)
      state.filter_pattern = value
      state.filter_type = "filename"
      M.navigate(state)
    end,
    on_close = function()
    end,
  })
end

M.setup = function(config, global_config)
end

return M
