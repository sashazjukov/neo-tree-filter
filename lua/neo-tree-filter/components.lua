local highlights = require("neo-tree.ui.highlights")
local common = require("neo-tree.sources.common.components")

local M = {}

M.custom = function(config, node, state)
	local text = node.extra.custom_text or ""
	local highlight = highlights.DIM_TEXT
	return {
		text = text .. " ",
		highlight = highlight,
	}
end

M.icon = function(config, node, state)
	local icon = config.default or " "
	local padding = config.padding or " "
	local highlight = config.highlight or highlights.FILE_ICON
	if node.type == "directory" then
		highlight = highlights.DIRECTORY_ICON
		if node:is_expanded() then
			icon = config.folder_open or "-"
		else
			icon = config.folder_closed or "+"
		end
	elseif node.type == "file" then
		local success, web_devicons = pcall(require, "nvim-web-devicons")
		if success then
			local devicon, hl = web_devicons.get_icon(node.name, node.ext)
			icon = devicon or icon
			highlight = hl or highlight
		end
	end
	return {
		text = icon .. padding,
		highlight = highlight,
	}
end

M.name = function(config, node, state)
	local highlight = config.highlight or highlights.FILE_NAME
	if node.type == "directory" then
		highlight = highlights.DIRECTORY_NAME
	end
	if node:get_depth() == 1 then
		highlight = highlights.ROOT_NAME
	end
	if node.id and node.id:find("^__filter__:") then
		local prefix_end = node.name:find(": ")
		if prefix_end then
			return {
				{ text = node.name:sub(1, prefix_end), highlight = highlight },
				{ text = node.name:sub(prefix_end + 2), highlight = highlights.FILTER_TERM },
			}
		end
	end
	local count_text = node.name:match("%s+%(%d+%)$")
	if count_text then
		local name_part = node.name:sub(1, -(#count_text + 1))
		return {
			{ text = name_part, highlight = highlight },
			{ text = count_text, highlight = highlights.FILTER_TERM },
		}
	end
	return {
		text = node.name,
		highlight = highlight,
	}
end

return vim.tbl_deep_extend("force", common, M)
