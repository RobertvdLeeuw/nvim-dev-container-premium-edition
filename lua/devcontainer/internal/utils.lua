local plugin_config = require("devcontainer.config")

local M = {}

M.path_sep = package.config:sub(1, 1)

function M.add_constructor(table)
  table.new = function(extras)
    local new_instance = {}
    setmetatable(new_instance, { __index = table })
    if extras and type(extras) == "table" and not vim.islist(extras) then
      for k, v in pairs(extras) do
        new_instance[k] = v
      end
    end
    return new_instance
  end
  return table
end

function M.get_image_cache_tag()
  local plugin_config = require("devcontainer.config")
  
  -- Use project root if available, otherwise fall back to workspace folder
  local project_root = plugin_config.find_project_root()
  local workspace_folder = project_root or plugin_config.workspace_folder_provider()
  
  -- Extract just the project directory name instead of the full path
  local project_name = workspace_folder:match("([^/\\]+)$") or workspace_folder
  -- Clean the project name - keep only alphanumeric characters and underscores
  project_name = string.gsub(project_name, "[^%w_]", "")
  project_name = string.lower(project_name)
  -- Ensure we have a valid name
  if project_name == "" or project_name == "." then
    project_name = "project"
  end
  return "nvim_dev_container_" .. project_name
end

return M
