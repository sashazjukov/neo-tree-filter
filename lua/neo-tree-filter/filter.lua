local M = {}

local function scan_directory(root, pattern, search_content)
  local results = {}
  local ok, regex = pcall(vim.regex, pattern)
  if not ok then
    vim.notify('Invalid regex pattern: ' .. pattern, vim.log.levels.ERROR)
    return results
  end

  local function scan(dir)
    local handle = vim.loop.fs_scandir(dir)
    if not handle then return end

    while true do
      local name, t = vim.loop.fs_scandir_next(handle)
      if not name then break end

      local full_path = dir .. '/' .. name

      if t == 'directory' then
        if not search_content then
          local match = regex:match_str(name)
          if match and match >= 0 then
            table.insert(results, {
              id = full_path,
              name = name,
              path = full_path,
              type = 'directory',
            })
          end
        end
        scan(full_path)
      elseif t == 'file' then
        if search_content then
          local content = io.open(full_path, 'r')
          if content then
            local lines = content:read('*a')
            content:close()
            local match = regex:match_str(lines)
            if match and match >= 0 then
              table.insert(results, {
                id = full_path,
                name = name,
                path = full_path,
                type = 'file',
              })
            end
          end
        else
          local match = regex:match_str(name)
          if match and match >= 0 then
            table.insert(results, {
              id = full_path,
              name = name,
              path = full_path,
              type = 'file',
            })
          end
        end
      end
    end
  end

  scan(root)
  return results
end

M.filter_by_filename = function(root, pattern)
  vim.notify('Filtering by filename: ' .. pattern .. ' in ' .. root, vim.log.levels.INFO)
  return scan_directory(root, pattern, false)
end

M.filter_by_content = function(root, pattern)
  vim.notify('Filtering by content: ' .. pattern .. ' in ' .. root, vim.log.levels.INFO)
  return scan_directory(root, pattern, true)
end

return M
