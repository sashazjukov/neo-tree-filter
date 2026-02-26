local cc = require("neo-tree.sources.common.commands")
local manager = require("neo-tree.sources.manager")
local source = require("neo-tree-filter.init")

local vim = vim

local M = {}

M.open_filter = function(state)
  source.open_filter_input(state)
end

M.refresh = function(state)
  manager.refresh("neo-tree-filter", state)
end

M.show_debug_info = function(state)
  print(vim.inspect(state))
end

cc._add_common_commands(M)
return M
