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

local is_new_navigation = true

local function rg_to_vim_pattern(pattern)
	pattern = pattern:gsub("%*%?", "{-}")
	pattern = pattern:gsub("([^*])%?", "%1\\=")
	pattern = pattern:gsub("^%?", "\\=")
	pattern = pattern:gsub("\\b(%w)", "<%1")
	pattern = pattern:gsub("(%w)\\b", "%1>")
	return "\\c\\v" .. pattern
end

local function prefix_node_ids(node, prefix)
	node.id = prefix .. node.id
	if node.children then
		for _, child in ipairs(node.children) do
			prefix_node_ids(child, prefix)
		end
	end
end

local function strip_id_prefix(id)
	return id:match("^__filter__:[^|]+|(.+)$") or id
end

local function propagate_filter_info(node, pattern, filter_type)
	node.filter_pattern = pattern
	node.filter_type = filter_type
	if node.children then
		for _, child in ipairs(node.children) do
			propagate_filter_info(child, pattern, filter_type)
		end
	end
end

M.navigate = function(state, path)
	if path == nil then
		path = state.path
	end
	if path == nil then
		path = vim.fn.getcwd()
	end
	state.path = path

	state.filters = state.filters or {}

	if is_new_navigation then
		state.filters = {}
		state.filter_pattern = ""
		state.filter_type = "filename"
	end

	local filter_pattern = state.filter_pattern or ""

	if filter_pattern ~= "" then
		local new_items
		if state.filter_type == "filename" then
			new_items = filter.filter_by_filename(path, filter_pattern)
		else
			new_items = filter.filter_by_content(path, filter_pattern)
		end
		for _, item in ipairs(new_items) do
			for i, f in ipairs(state.filters) do
				if f.id == item.id then
					table.remove(state.filters, i)
					break
				end
			end
			propagate_filter_info(item, filter_pattern, state.filter_type)
			local ns = item.id .. "|"
			if item.children then
				for _, child in ipairs(item.children) do
					prefix_node_ids(child, ns)
					if child.type == "directory" then
						child._is_expanded = false
					end
				end
			end
			table.insert(state.filters, 1, item)
		end
		state.last_filter_pattern = filter_pattern
		state.last_filter_type = state.filter_type
	end

	local items = {}
	if is_new_navigation then
		table.insert(items, {
			id = "__filter__:welcome",
			name = "Regex Content Filter",
			path = state.path,
			type = "directory",
			children = {},
			_is_expanded = true,
		})
	end
	for i, f in ipairs(state.filters) do
		if i > 1 then
			table.insert(items, {
				id = "__filter__:separator:" .. i,
				name = string.rep("─", 30),
				path = state.path,
				type = "file",
			})
		end
		table.insert(items, f)
	end

	renderer.show_nodes(items, state)

	vim.keymap.set("n", "f", function()
		M.open_filter_input(state)
	end, { buffer = state.tree.bufnr, noremap = true, desc = "show filter input" })

	vim.keymap.set("n", "<F11>c", function()
		M.remove_filter_node(state)
	end, { buffer = state.tree.bufnr, noremap = true, desc = "remove filter node under cursor" })

	vim.keymap.set("n", "<F11>a", function()
		M.clear_all_filters(state)
	end, { buffer = state.tree.bufnr, noremap = true, desc = "clear all filter nodes" })

	if previous_win and vim.api.nvim_win_is_valid(previous_win) then
		vim.api.nvim_set_current_win(previous_win)
	end

	if is_new_navigation then
		vim.defer_fn(function()
			M.open_filter_input(state, "filename")
		end, 100)
	end
	is_new_navigation = false
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

M.remove_filter_node = function(state)
	if not (state and state.tree) then
		return
	end
	local node = state.tree:get_node()
	if not node then
		return
	end
	local node_id = node:get_id()
	for i, f in ipairs(state.filters) do
		local prefix = f.id .. "|"
		if node_id == f.id or node_id:sub(1, #prefix) == prefix then
			table.remove(state.filters, i)
			break
		end
	end
	state.filter_pattern = ""
	M.navigate(state, state.path)
end

M.clear_all_filters = function(state)
	if not state then
		return
	end
	state.filters = {}
	state.filter_pattern = ""
	state.last_filter_pattern = nil
	state.last_filter_type = nil
	M.navigate(state, state.path)
end

M.open_and_search = function(state)
	local tree = state.tree
	local node = tree:get_node()
	local path = strip_id_prefix(node:get_id())
	local pattern = node.filter_pattern or state.last_filter_pattern
	local filter_type = node.filter_type or state.last_filter_type

	vim.cmd("edit " .. path)

	if filter_type == "content" and pattern then
		vim.cmd("/" .. rg_to_vim_pattern(pattern))
	end
end

M.setup = function(config, global_config)
	local function get_visual_selection()
		local start_pos = vim.api.nvim_buf_get_mark(0, "<")
		local end_pos = vim.api.nvim_buf_get_mark(0, ">")
		local start_row, start_col = start_pos[1], start_pos[2]
		local end_row, end_col = end_pos[1], end_pos[2]

		if start_row == 0 or end_row == 0 then
			return ""
		end

		local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
		if #lines == 0 then
			return ""
		end

		if #lines == 1 then
			lines[1] = lines[1]:sub(start_col + 1, end_col + 1)
		else
			lines[1] = lines[1]:sub(start_col + 1)
			lines[#lines] = lines[#lines]:sub(1, end_col + 1)
		end

		return table.concat(lines, "\n")
	end

	vim.keymap.set("n", "<F12>ff", function()
		local word = vim.fn.expand("<cword>")

		require("neo-tree.command").execute({ source = M.name })

		local state = manager.get_state(M.name)
		if state then
			state.filter_pattern = word
			M.open_filter_input(state)
		end
	end, { desc = "Filter neo-tree with word under cursor" })

	vim.keymap.set("v", "<F12>ff", function()
		vim.cmd("normal! \027")
		local word = get_visual_selection()

		if word == "" then
			return
		end

		require("neo-tree.command").execute({ source = M.name })

		local state = manager.get_state(M.name)
		if state then
			state.filter_pattern = word
			M.open_filter_input(state)
		end
	end, { desc = "Filter neo-tree with visual selection" })

	local function find_node_by_path(node, path)
		if node.path == path then
			return node
		end
		if node.children then
			for _, child in ipairs(node.children) do
				local found = find_node_by_path(child, path)
				if found then
					return found
				end
			end
		end
	end

	local function find_filter_node(filters, path)
		for _, f in ipairs(filters) do
			local found = find_node_by_path(f, path)
			if found then
				return found
			end
		end
	end

	-- Subscribe to file open event
	manager.subscribe(M.name, {
		event = events.FILE_OPENED,
		handler = function(args)
			local state = manager.get_state(M.name)
			if not state then
				return
			end
			local node = find_filter_node(state.filters, args)
			local filter_type = node and node.filter_type or state.last_filter_type
			local pattern = node and node.filter_pattern or state.last_filter_pattern
			if filter_type == "content" and pattern then
				vim.cmd("/" .. rg_to_vim_pattern(pattern))
			end
		end,
	})
end

return M
