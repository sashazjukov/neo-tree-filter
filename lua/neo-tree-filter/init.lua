local vim = vim
local renderer = require("neo-tree.ui.renderer")
local manager = require("neo-tree.sources.manager")
local events = require("neo-tree.events")
local utils = require("neo-tree.utils")

local M = {
	name = "neo-tree-filter",
	display_name = " Content Filter ",
}

local filter = require("neo-tree-filter.filter")
local floating_input = require("neo-tree-filter.floating-input")

local previous_win = nil

M.navigate = function(state, path)
	local is_new_navigation = (path == nil)

	if path == nil then
		path = state.path
	end
	if path == nil then
		path = vim.fn.getcwd()
	end
	state.path = path

	local filter_pattern = state.filter_pattern or ""
	local filter_type = state.filter_type or "filename"

	local items

	if is_new_navigation then
		state.filter_pattern = ""
		state.filter_type = "filename"
		filter_pattern = ""
		items = {
			{
				id = "placeholder",
				name = "Press Enter to type regex filter",
				type = "message",
			},
		}
		vim.defer_fn(function()
			M.open_filter_input(state, "filename")
		end, 100)
	elseif filter_pattern == "" then
		items = {
			{
				id = "placeholder",
				name = "Press Enter to type regex filter",
				type = "message",
			},
		}
		vim.defer_fn(function()
			M.open_filter_input(state, "filename")
		end, 100)
	elseif filter_type == "filename" then
		items = filter.filter_by_filename(path, filter_pattern)
	else
		items = filter.filter_by_content(path, filter_pattern)
	end

	renderer.show_nodes(items, state)

	if previous_win and vim.api.nvim_win_is_valid(previous_win) then
		vim.api.nvim_set_current_win(previous_win)
	end
end

M.open_filter_input = function(state, filter_type)
	previous_win = vim.api.nvim_get_current_win()
	filter_type = filter_type or "filename"
	floating_input.open({
		default_text = state.filter_pattern or "",
		filter_type = filter_type,
		on_submit = function(value, type)
			state.filter_pattern = value
			state.filter_type = type
			M.navigate(state, state.path)
		end,
		on_close = function() end,
	})
end

M.open_and_search = function(state)
	local tree = state.tree
	local node = tree:get_node()
	local path = node:get_id()

	local filter_pattern = state.filter_pattern or ""
	local filter_type = state.filter_type or "filename"

	vim.cmd("edit " .. path)

	if filter_type == "content" and filter_pattern ~= "" then
		vim.cmd("/" .. filter_pattern)
	end
end

M.setup = function(config, global_config)
	-- Subscribe to file open event
	manager.subscribe(M.name, {
		event = events.FILE_OPENED,
		handler = function(args)
			local state = manager.get_state(M.name)
			if state and state.filter_type == "content" and state.filter_pattern then
				vim.cmd("/" .. state.filter_pattern)
			end
		end,
	})
end

return M
