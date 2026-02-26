local NuiInput = require("nui.input")
local popups = require("neo-tree.ui.popups")

local M = {}

local current_input = nil

M.open = function(opts)
    opts = opts or {}
    local on_submit = opts.on_submit or function() end
    local on_close = opts.on_close or function() end
    local default_text = opts.default_text or ''
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
        on_submit = function(value)
            if value and value ~= '' then
                on_submit(value, filter_type)
            end
        end,
        on_close = function()
            -- current_input = nil
            -- on_close()
        end,
    })

    input:map("i", "<F12>", function()
        local lines = vim.api.nvim_buf_get_lines(input.bufnr, 0, -1, false)
        local raw = lines[1] or ''
        local value = raw:match("^.+: (.*)$") or raw
        if value and value ~= '' then
            local new_type = filter_type == "filename" and "content" or "filename"
            on_submit(value, new_type)
        end
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
