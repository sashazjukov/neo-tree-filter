local M = {
  name = "neo-tree-filter",
  display_name = " Filter ",
}

local function get_state(tabid)
  return require("neo-tree.sources.manager").get_state(M.name, tabid)
end

function M.setup(config, global_config)
  vim.notify("neo-tree-filter source setup called", vim.log.levels.DEBUG)
end

function M.navigate(state, path, path_to_reveal, callback, async)
  local ok, renderer = pcall(require, "neo-tree.ui.renderer")
  if not ok then
    vim.notify("Failed to load neo-tree.ui.renderer: " .. renderer, vim.log.levels.ERROR)
    return
  end
  local ok2, manager = pcall(require, "neo-tree.sources.manager")
  if not ok2 then
    vim.notify("Failed to load neo-tree.sources.manager: " .. manager, vim.log.levels.ERROR)
    return
  end

  local scan_path = path
  if not scan_path then
    scan_path = state.path or manager.get_cwd(state)
  end
  state.path = scan_path

  local filter_pattern = state.filter_pattern or ""
  local filter_type = state.filter_type or "filename"

  local filter = require("neo-tree-filter.filter")
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
    items = filter.filter_by_filename(scan_path, filter_pattern)
  else
    items = filter.filter_by_content(scan_path, filter_pattern)
  end

  renderer.show_nodes(items, state)
end

return M
