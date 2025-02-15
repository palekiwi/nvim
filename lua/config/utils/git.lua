local gs = require('gitsigns')
local nt = require('neo-tree.command')

M = {}

local function toggle_git_tree(action, toggle)
  nt.execute({
    action = action,
    position = "right",
    toggle = toggle,
    source = "git_status",
    git_base = vim.g.git_base
  })
end

local function set_base_branch(branch)
  local base_branch = branch or "master"

  vim.g.git_base = base_branch

  gs.change_base(base_branch, true)
  toggle_git_tree("show", false)

  vim.notify("Base branch: " .. base_branch)
end

M.set_base_branch = function(branch) set_base_branch(branch) end

M.toggle_git_tree = function(action) toggle_git_tree(action, true) end

M.diffthis = function(vertical) gs.diffthis(nil, { vertical = vertical }) end

M.prev_hunk = function()
  gs.nav_hunk("prev", { preview = false, wrap = true })
end

M.next_hunk = function()
  gs.nav_hunk("next", { preview = false, wrap = true })
end

M.hunks_to_loclist = function() gs.setqflist("attached", { use_location_list = true, open = true }) end

M.changed_files_to_loclist = function()
  local base_branch = vim.g.git_base or "master"
  local command = "git diff --name-only --diff-filter=d $(git merge-base HEAD " .. base_branch .. " )"

  local list = vim.fn.systemlist(command)

  vim.fn.setloclist(0, {}, 'r', { title = 'Changed files', efm = '%f', lines = list })

  vim.notify("Loclist set to changed files")
end

return M
