local M = {}

M.custom = function(config, node, state)
  return {
    text = node.extra.custom_text or "",
    highlight = "Comment",
  }
end

M.icon = function(config, node, state)
  local icon = config.default or " "
  local padding = config.padding or " "
  local highlight = config.highlight or "NeoTreeFileIcon"
  if node.type == "directory" then
    highlight = "NeoTreeDirectoryIcon"
    if node:is_expanded() then
      icon = config.folder_open or "-"
    else
      icon = config.folder_closed or "+"
    end
  end
  return {
    text = icon .. padding,
    highlight = highlight,
  }
end

return M
