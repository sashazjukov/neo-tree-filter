local M = {}

local function build_node_tree(root, items)
	local nodes_by_path = {}

	for _, item in ipairs(items) do
		local filepath = type(item) == "table" and item.path or item
		local count = type(item) == "table" and item.count or nil

		if filepath ~= "" then
			local parts = {}
			local p = filepath
			while p ~= root and p ~= root .. "/" and p ~= "/" do
				table.insert(parts, 1, p)
				local parent = vim.fn.fnamemodify(p, ":h")
				if parent == p then
					break
				end
				p = parent
			end

			for i, path in ipairs(parts) do
				if not nodes_by_path[path] then
					local name = vim.fn.fnamemodify(path, ":t")
					local is_file = i == #parts
					nodes_by_path[path] = {
						id = path,
						name = is_file and count and (name .. " (" .. count .. ")") or name,
						path = path,
						type = is_file and "file" or "directory",
						children = is_file and nil or {},
					}
				end
			end
		end
	end

	local top_level = {}
	for path, node in pairs(nodes_by_path) do
		local parent = vim.fn.fnamemodify(path, ":h")
		if parent == root or parent == root .. "/" then
			table.insert(top_level, node)
		elseif nodes_by_path[parent] then
			table.insert(nodes_by_path[parent].children, node)
		end
	end

	local function sort_nodes(nodes)
		table.sort(nodes, function(a, b)
			if a.type ~= b.type then
				return a.type == "directory"
			end
			return a.name < b.name
		end)
		for _, node in ipairs(nodes) do
			if node.children then
				sort_nodes(node.children)
			end
		end
	end
	sort_nodes(top_level)

	return top_level
end

local function scan_directory(root, pattern, search_content)
	local ok, regex
	local matched_files = {}

	if search_content then
		local output = vim.fn.systemlist({ "rg", "-ic", "--", pattern, root })
		if vim.v.shell_error ~= 0 and vim.v.shell_error ~= 1 then
			return {}
		end
		for _, line in ipairs(output) do
			if line ~= "" then
				local colon_pos = line:find(":%d+$")
				if colon_pos then
					local filepath = line:sub(1, colon_pos - 1)
					local count = tonumber(line:sub(colon_pos + 1))
					table.insert(matched_files, { path = filepath, count = count })
				end
			end
		end
	else
		local output = vim.fn.systemlist({ "rg", "--files", root })
		if vim.v.shell_error ~= 0 then
			return {}
		end
		ok, regex = pcall(vim.regex, pattern .. "\\c")
		if not ok then
			vim.notify("Invalid regex pattern: " .. pattern, vim.log.levels.ERROR)
			return {}
		end
		for _, filepath in ipairs(output) do
			if filepath ~= "" then
				local name = vim.fn.fnamemodify(filepath, ":t")
				local match = regex:match_str(name)
				if match and match >= 0 then
					table.insert(matched_files, filepath)
				end
			end
		end
	end

	local items = build_node_tree(root, matched_files)
	local prefix = search_content and "c" or "f"
	return {
		{
			id = "__filter__:" .. root .. ":" .. pattern,
			name = prefix .. ": " .. pattern,
			path = root,
			type = "directory",
			children = items,
		},
	}
end

M.filter_by_filename = function(root, pattern)
	return scan_directory(root, pattern, false)
end

M.filter_by_content = function(root, pattern)
	return scan_directory(root, pattern, true)
end

return M
