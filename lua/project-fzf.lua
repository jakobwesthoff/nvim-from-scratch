-- Dependencies
local has_fzf_lua, fzf_lua = pcall(require, 'fzf-lua')
if not has_fzf_lua then
  error("fzf-lua is a dependency of project-fzf")
  return
end

local has_project, project = pcall(require, 'project_nvim')
if not has_project then
  error("project_nvim is a dependency of project-fzf")
  return
end

local history = require("project_nvim.utils.history")
local project = require("project_nvim.project")
local config = require("project_nvim.config")

local M = {}

local function format_for_display(project_path)
  local name = project_path:match("/([^/]+)$")
  return name, string.format("%-30s %s", name, project_path)
end

local function get_project_data(projects_data, selection)
  if not selection or #selection < 1 then
    return
  end

  local selected = selection[1]
  local data = projects_data[selected]

  if data == nil then
    error("Selected entry does not have data in the backing store. Should not be possible")
    return {}
  end

  return data
end

local function change_working_directory_by_selection(projects_data, selection)
  local data = get_project_data(projects_data, selection)
  if data == nil then return false, {} end
  local cd_successful = project.set_pwd(data.path, "fzf-lua")
  return cd_successful, data
end


function M.projects()
  local recent_projects = history.get_recent_projects()
  for i = 1, math.floor(#recent_projects / 2) do
    recent_projects[i], recent_projects[#recent_projects - i + 1] = recent_projects[#recent_projects - i + 1], recent_projects[i]
  end

  local projects_display = {}
  local projects_data = {}
  for _, project_path in ipairs(recent_projects) do
    local name, display = format_for_display(project_path)
    table.insert(projects_display, display)
    projects_data[display] = {
      name = name,
      path = project_path
    }
  end

  fzf_lua.fzf_exec(
    projects_display,
    {
      prompt = "Projects > ",
      actions = {
        default = function(selection)
          local cd_successful, _ = change_working_directory_by_selection(projects_data, selection)
          local opts = {
            hidden = config.options.show_hidden,
          }

          if cd_successful then
            fzf_lua.files(opts)
          end
        end,
        ["ctrl-s"] = function(selection)
          local cd_successful, _ = change_working_directory_by_selection(projects_data, selection)
          local opts = {
            hidden = config.options.show_hidden,
          }

          if cd_successful then
            fzf_lua.live_grep(opts)
          end
        end,
        ["ctrl-r"] = function(selection)
          local cd_successful, data = change_working_directory_by_selection(projects_data, selection)
          if data == nil then return end

          local opts = {
            cwd = data.path,
            cwd_only = true,
            hidden = config.options.show_hidden,
          }

          if cd_successful then
            fzf_lua.oldfiles(opts)
          end
        end,
        ["ctrl-d"] = function(selection)
          local data = get_project_data(projects_data, selection)
          if data == nil then return end

          local choice = vim.fn.confirm("Delete '" .. data.name .. "' from project list?", "&Yes\n&No", 2)

          if choice == 1 then
            history.delete_project({value = data.path})
            M.projects()
          end
        end,
        ["ctrl-w"] = function(selection)
         local _, _ = change_working_directory_by_selection(projects_data, selection)
        end
      }
    }
  )

end

function M.setup()
  print("Setup called")
end

return M
