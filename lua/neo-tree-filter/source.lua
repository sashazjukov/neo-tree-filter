local M = {
  name = "neo-tree-filter",
  display_name = " Filter ",
}

local function get_state(tabid)
  return require("neo-tree.sources.manager").get_state(M.name, tabid)
end

function M.setup(config, global_config)
end

function M.navigate(state, path, path_to_reveal, callback, async)
  local renderer = require("neo-tree.ui.renderer")
  local manager = require("neo-tree.sources.manager")

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
