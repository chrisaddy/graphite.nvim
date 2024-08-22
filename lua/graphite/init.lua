local ok, telescope = pcall(require, 'telescope')
if not ok then
  vim.notify('This plugin requires telescope.nvim', vim.log.levels.ERROR)
  return
end

local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local conf = require('telescope.config').values
--
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
--
local M = {}
local execute_command = function(cmd)
  local handle = io.popen(cmd)
  local result = handle:read '*a'
  handle:close()
  return result
end

local list_graphite_branches = function()
  local output = execute_command 'gt ls'
  local branches = {}
  for branch in output:gmatch '[^\r\n]+' do
    table.insert(branches, branch)
  end
  print('found ' .. #branches .. ' branches')
  return branches
end

local clean_branch_name = function(name)
  return name:match '%S+$'
end

local checkout_graphite_branch = function(branch)
  print('checking out branch=' .. branch)
  execute_command('gt checkout ' .. branch)
end

M.graphite_branches = function()
  print 'gt ls'
  local branches = list_graphite_branches()

  pickers
    .new({}, {
      prompt_title = 'gt branches',
      finder = finders.new_table {
        results = branches,
      },
      sorter = conf.generic_sorter {},
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          local branch = clean_branch_name(selection[1])
          checkout_graphite_branch(branch)
        end)
        return true
      end,
    })
    :find()
end

-- to execute the function
--
-- vim.api.nvim_echo 'hello'
--
function M.setup()
  vim.api.nvim_create_user_command('GraphiteBranches', M.graphite_branches, {})
end

M.setup()
return M
--
-- -- Function to checkout a Graphite branch
-- local function checkout_graphite_branch(branch)
--   execute_command('graphite branch checkout ' .. branch)
-- end
--
-- -- Telescope picker for Graphite branches
--
-- -- Set up the plugin
-- function M.setup()
--   vim.api.nvim_create_user_command('GraphiteBranches', M.graphite_branches, {})
-- end
--
-- -- Automatically set up the plugin
-- M.setup()
--
-- return M
