local NuiInput = require("nui.input")
local popups = require("neo-tree.ui.popups")

local M = {}

local current_input = nil

local history = {}
local history_index = nil
local max_history = 50

local function add_to_history(value)
	if #history > 0 and history[#history] == value then
		return
	end
	for i = #history, 1, -1 do
		if history[i] == value then
			table.remove(history, i)
			break
		end
	end
	table.insert(history, value)
	if #history > max_history then
		table.remove(history, 1)
	end
end

M.open = function(opts)
	M.close()

	opts = opts or {}
	local on_submit = opts.on_submit or function() end
	local on_close = opts.on_close or function() end
	local default_text = opts.default_text or ""
	local filter_type = opts.filter_type or "filename"

	local winid = vim.api.nvim_get_current_win()
	local height = vim.api.nvim_win_get_height(winid)

	local popup_options = popups.popup_options("Filter (" .. filter_type .. "): ", 40, {
		relative = "win",
		position = { row = height - 2, col = 0 },
		size = 80,
	})

	local input_prompt = " "

	local input = NuiInput(popup_options, {
		prompt = input_prompt,
		default_value = default_text,
		on_submit = function(value) end,
		on_close = function()
			current_input = nil
			on_close()
		end,
	})

	local function refocus()
		if input.winid and vim.api.nvim_win_is_valid(input.winid) then
			vim.api.nvim_set_current_win(input.winid)
		end
	end

	local function trim(s)
		return s:match("^%s*(.-)%s*$")
	end

	local function set_buffer_line(text)
		vim.api.nvim_buf_set_lines(input.bufnr, 0, -1, false, { input_prompt .. text })
	end

	local function submit_filename()
		local lines = vim.api.nvim_buf_get_lines(input.bufnr, 0, -1, false)
		local value = trim(lines[1] or "")
		if value ~= "" then
			add_to_history(value)
			on_submit(value, "filename")
			refocus()
			input:unmount()
		end
	end

	local function submit_content()
		local lines = vim.api.nvim_buf_get_lines(input.bufnr, 0, -1, false)
		local value = trim(lines[1] or "")
		if value ~= "" then
			add_to_history(value)
			on_submit(value, "content")
			refocus()
			input:unmount()
		end
	end

	history_index = #history + 1

	local function navigate_history(direction)
		local new_index
		if direction == "up" then
			new_index = math.max(history_index - 1, 1)
		else
			new_index = math.min(history_index + 1, #history + 1)
		end
		if new_index == history_index then
			return
		end
		history_index = new_index
		if history_index <= #history then
			set_buffer_line(history[history_index])
		else
			set_buffer_line("")
		end
		local line = vim.api.nvim_buf_get_lines(input.bufnr, 0, -1, false)[1] or ""
		vim.api.nvim_win_set_cursor(input.winid, { 1, #line - #input_prompt })
	end

	for _, mode in ipairs({ "i", "n" }) do
		input:map(mode, "<Enter>", submit_filename, { noremap = true })
		input:map(mode, "<F12>", submit_content, { noremap = true })
		input:map("n", "<Up>", function()
			navigate_history("up")
		end, { noremap = true })
		input:map("n", "<Down>", function()
			navigate_history("down")
		end, { noremap = true })
	end

	input:map("n", "<Esc>", function()
		input:unmount()
	end, { noremap = true })

	current_input = input
	input:mount()
	vim.cmd("startinsert!")
end

M.close = function()
	if current_input then
		current_input:unmount()
		current_input = nil
	end
end

M.is_open = function()
	return current_input ~= nil
end

return M
