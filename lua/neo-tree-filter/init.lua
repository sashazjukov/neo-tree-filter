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
        name = "No filter - open input to type regex",
        type = "message",
      }
    }
  elseif filter_type == "filename" then
    items = filter.filter_by_filename(path, filter_pattern)
  else
    items = filter.filter_by_content(path, filter_pattern)
  end

  renderer.show_nodes(items, state)
end

M.setup = function(config, global_config)
  vim.notify("neo-tree-filter setup called", vim.log.levels.DEBUG)
end

return M
