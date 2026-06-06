local NuiInput = require("nui.input")
local popups = require("neo-tree.ui.popups")

local M = {}

local current_input = nil

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
	})

	local input = NuiInput(popup_options, {
		prompt = " ",
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

	local function submit_filename()
		local lines = vim.api.nvim_buf_get_lines(input.bufnr, 0, -1, false)
		local value = (lines[1] or ""):gsub("^%s+", "")
		if value ~= "" then
			on_submit(value, "filename")
			refocus()
		end
	end

	local function submit_content()
		local lines = vim.api.nvim_buf_get_lines(input.bufnr, 0, -1, false)
		local value = (lines[1] or ""):gsub("^%s+", "")
		if value ~= "" then
			on_submit(value, "content")
			refocus()
		end
	end

	for _, mode in ipairs({ "i", "n" }) do
		input:map(mode, "<Enter>", submit_filename, { noremap = true })
		input:map(mode, "<F12>", submit_content, { noremap = true })
	end

	input:map("n", "<Esc>", function()
		input:unmount()
	end, { noremap = true })

	current_input = input
	input:mount()
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
