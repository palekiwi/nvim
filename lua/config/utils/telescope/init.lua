local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local previewers = require "telescope.previewers"
local make_entry = require "telescope.make_entry"
local entry_display = require "telescope.pickers.entry_display"
local builtin = require 'telescope.builtin'

local git_utils = require('config.utils.git')
local gh_utils = require('config.utils.gh')

local custom_previewers = require('config.utils.telescope.previewers')

M = {}

local search_tags_opts = {
  fname_width = 60,
  show_line = false,
  only_sort_tags = true
}

M.search_cword = function()
  builtin.grep_string {
    default_text = vim.fn.expand("<cfile>"),
    word_match = "-w"
  }
end

M.search_tags = function()
  builtin.tags(search_tags_opts)
end

M.search_tags_cword = function()
  local opts = vim.tbl_extend('force',
    search_tags_opts,
    { default_text = vim.fn.expand("<cword>") }
  )
  builtin.tags(opts)
end

M.lsp_references = function()
  builtin.lsp_references({
    include_declaration = true,
    fname_width = 60,
    show_line = false,
    trim_text = false
  })
end

local last_commit_on_base = function()
  local last_commit_on_base = vim.fn.system({
    "git",
    "merge-base",
    "HEAD",
    vim.g.git_base or "master"
  })

  assert(vim.v.shell_error == 0, last_commit_on_base)

  return last_commit_on_base
end

-- search in files that have changed since a particular commit (base branch)
M.changed_files = function(opts)
  local success, result = pcall(last_commit_on_base)

  if not success then
    return vim.api.nvim_echo({
      { "Changed files: " .. result, "ErrorMsg" },
    }, true, {})
  end

  local files = vim.fn.systemlist("git diff --name-only " .. result)

  opts = {
    attach_mappings = function(_prompt_bufnr, map)
      map('i', '<C-l>', actions.smart_send_to_loclist + actions.open_loclist)

      return true
    end
  }

  pickers.new(opts, {
    prompt_title = "changed files",
    finder = finders.new_table {
      results = files,
      entry_maker = make_entry.gen_from_file(opts)
    },
    previewer = custom_previewers.file_diff_previewer,
    sorter = conf.generic_sorter(opts),
  }):find()
end

-- live grep in change files
M.grep_changed_files = function(_opts)
  local success, result = pcall(last_commit_on_base)

  if not success then
    return vim.api.nvim_echo({
      { "Changed files: " .. result, "ErrorMsg" },
    }, true, {})
  end

  local files = vim.fn.systemlist("git diff --name-only " .. result)

  builtin.live_grep {
    prompt_title = "Grep in Changed Files",
    search_dirs = files
  }
end

M.changed_files_since = function(opts)
  local success, result = pcall(last_commit_on_base)

  if not success then
    return vim.api.nvim_echo({
      { "Changed files: " .. result, "ErrorMsg" },
    }, true, {})
  end

  local base = vim.g.git_base or "master"
  local commits = vim.fn.systemlist("git rev-list --ancestry-path " .. base .. "..HEAD --no-merges")

  local files = {};

  for _, commit in ipairs(commits) do
    local changed_in_commit = vim.fn.systemlist("git diff-tree --no-commit-id --name-only -r " .. commit)
    files = vim.fn.extend(files, changed_in_commit)
  end

  opts = opts or {}

  pickers.new(opts, {
    prompt_title = "changed files",
    finder = finders.new_table {
      results = files,
      entry_maker = make_entry.gen_from_file(opts)
    },
    previewer = custom_previewers.file_diff_previewer,
    sorter = conf.generic_sorter(opts),
  }):find()
end

M.diffview_since = function()
  local success, result = pcall(last_commit_on_base)

  if not success then
    return vim.api.nvim_echo({
      { "Changed files: " .. result, "ErrorMsg" },
    }, true, {})
  end

  local base = vim.g.git_base or "master"
  local commits = vim.fn.systemlist("git rev-list --ancestry-path " .. base .. "..HEAD --no-merges")

  local files = {};

  for _, commit in ipairs(commits) do
    local changed_in_commit = vim.fn.systemlist("git diff-tree --no-commit-id --name-only -r " .. commit)
    files = vim.fn.extend(files, changed_in_commit)
  end

  local cmd = "DiffviewOpen " .. base .. " -- " .. vim.fn.join(files, " ")
  vim.cmd(cmd)
end

local gen_from_git_commits = function(opts)
  opts = opts or {}

  local displayer = entry_display.create {
    separator = " ",
    items = {
      { width = 10 },
      { width = 10 },
      { width = 21 },
      { remaining = true },
    },
  }

  local make_display = function(entry)
    return displayer {
      { entry.value,  "TelescopeResultsComment" },
      { entry.date,   "TelescopePreviewDate" },
      { entry.author, "TelescopePreviewUser" },
      { entry.msg,    "TelescopePreviewMessage" }
    }
  end

  return function(entry)
    if entry == "" then
      return nil
    end

    local sha, date_, time, _, rest = string.match(entry, "([^ ]+) ([^ ]+) ([^ ]+) ([^ ]+) (.*)")
    local author = string.sub(rest, 1, 21)
    local msg = string.gsub(string.sub(rest, 22), "^%s+", "")

    local date ---@type string
    if date_ == os.date("%Y-%m-%d") then
      date = time
    else
      date = date_
    end

    return make_entry.set_default_entry_mt({
      value = sha,
      ordinal = sha .. " " .. date .. " " .. author .. " " .. msg,
      date = date,
      author = author,
      msg = msg,
      display = make_display,
      current_file = opts.current_file,
    }, opts)
  end
end

local gen_from_pr_commits = function(opts)
  opts = opts or {}

  local displayer = entry_display.create {
    separator = " ",
    items = {
      { width = 10 },
      { width = 10 },
      { width = 21 },
      { width = 6 },
      { remaining = true },
    },
  }

  local make_display = function(entry)
    return displayer {
      { entry.value,  "TelescopeResultsComment" },
      { entry.date,   "TelescopePreviewDate" },
      { entry.author, "TelescopePreviewUser" },
      { entry.number, "TelescopeResultsComment" },
      { entry.msg,    "TelescopePreviewMessage" }
    }
  end

  return function(entry)
    if entry == "" then
      return nil
    end

    local sha, date_, time, _, rest = string.match(entry, "([^ ]+) ([^ ]+) ([^ ]+) ([^ ]+) (.*)")
    local author = string.sub(rest, 1, 21)
    local number, msg = string.sub(rest, 22):match("Merge pull request (#%d+) from [^%s]+ (.+)")

    number = number or string.sub(rest, 22):match("Merge pull request (#%d+).*")
    msg = msg or ""

    local date ---@type string
    if date_ == os.date("%Y-%m-%d") then
      date = time
    else
      date = date_
    end

    return make_entry.set_default_entry_mt({
      value = sha,
      ordinal = sha .. " " .. date .. " " .. author .. " " .. number .. " " .. msg,
      date = date,
      author = author,
      msg = msg,
      number = number,
      display = make_display,
      current_file = opts.current_file,
    }, opts)
  end
end

-- list "PR commits", i.e. commits that are present on current branch
-- but absent on the base branch
M.git_commits = function(opts)
  local base_branch = os.getenv("GIT_BASE") or "master"
  local command = "git log --pretty=format:'%h %ai %<(20)%an %s' " .. "HEAD ^" .. base_branch

  local handle = assert(io.popen(command))
  local result = handle:read("*a")
  handle:close()

  local files = {}
  for token in string.gmatch(result, "[^\n]+") do
    table.insert(files, token)
  end

  opts = {
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local picker = action_state.get_current_picker(prompt_bufnr)
        local selection = picker:get_multi_selection() ---@type table?

        if selection == nil or vim.tbl_isempty(selection) then
          local hash = action_state.get_selected_entry().value ---@type string

          actions.close(prompt_bufnr)

          vim.cmd(string.format("DiffviewOpen %s^!", hash))
          return
        end

        local size = #selection
        local first ---@type string
        local last ---@type string

        if size == 1 then
          first = selection[1].value ---@type string
          last = "HEAD"
        else
          first = selection[1].value ---@type string
          last = selection[size].value ---@type string
        end

        actions.close(prompt_bufnr)
        vim.cmd(string.format("DiffviewOpen %s...%s", first, last))
      end)

      map('i', '<C-h>', function()
        local hash = action_state.get_selected_entry().value ---@type string
        vim.fn.setreg('+', hash)

        actions.close(prompt_bufnr)
      end)

      map('i', '<C-y>', function()
        local hash = action_state.get_selected_entry().value ---@type string
        gh_utils.copy_commit_url(hash)

        actions.close(prompt_bufnr)
      end)

      map('i', '<C-b>', function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local git_base = selection.value ---@type string

        git_utils.set_base_branch(git_base)
      end)

      return true
    end
  }

  pickers.new(opts, {
    prompt_title = "PR Commits",
    layout_config = {
      preview_height = 0.5,
    },

    finder = finders.new_table {
      results = files,
      entry_maker = gen_from_git_commits(opts)
    },
    previewer = {
      custom_previewers.diff_previewer,
      custom_previewers.changed_files_tree_previewer,
    },
    sorter = conf.generic_sorter(opts),
  }):find()
end

M.git_pr_merge_commits = function(opts)
  local command = "git log --pretty=format:'%h %ai %<(20)%an %s %b' --merges --grep='Merge pull request' -n 1000"

  local handle = assert(io.popen(command))
  local result = handle:read("*a")
  handle:close()

  local commits = {}
  for token in string.gmatch(result, "[^\n]+") do
    -- local line = token:gsub("Merge pull request ", ""):gsub(" from [^%s]*", "")
    table.insert(commits, token)
  end

  opts = {
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local hash = action_state.get_selected_entry().value ---@type string
        actions.close(prompt_bufnr)
        vim.cmd(string.format("DiffviewOpen %s^!", hash))
      end)

      map('i', '<C-y>', function()
        local msg = action_state.get_selected_entry().msg ---@type string
        gh_utils.copy_pr_url_from_message(msg)

        actions.close(prompt_bufnr)
      end)

      map('i', '<C-h>', function()
        local hash = action_state.get_selected_entry().value ---@type string
        vim.fn.setreg('+', hash)

        actions.close(prompt_bufnr)
      end)

      return true
    end
  }

  local changed_files_previewer = previewers.new_buffer_previewer({
    title = "Changed Files",
    define_preview = function(self, entry, _status)
      local commit_hash = entry.value:match("^(%w+)") ---@type string

      -- Get just the file names
      local changed_files = vim.fn.system(string.format(
        "git diff --name-status %s^1..%s",
        commit_hash,
        commit_hash
      ))

      local lines = {}
      for filename in changed_files:gmatch("[^\n]+") do
        if filename ~= "" then
          table.insert(lines, filename)
        end
      end

      vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)

      -- Add syntax highlighting for git status
      vim.api.nvim_buf_call(self.state.bufnr, function()
        vim.cmd("syntax clear")
        vim.cmd("syntax match GitAdded /^A\\s.*$/")
        vim.cmd("syntax match GitDeleted /^D\\s.*$/")
        vim.cmd("syntax match GitRenamed /^R[0-9]*\\s.*$/")
        vim.cmd("syntax match GitCopied /^C[0-9]*\\s.*$/")

        vim.cmd("highlight GitAdded ctermfg=Green guifg=#6e9440")
        vim.cmd("highlight GitDeleted ctermfg=Red guifg=#cc6666")
        vim.cmd("highlight GitRenamed ctermfg=Blue guifg=#85678f")
        vim.cmd("highlight GitCopied ctermfg=Cyan guifg=#de935f")
      end)
    end,
  })


  pickers.new(opts, {
    prompt_title = "PR Merge Commits",
    layout_config = {
      preview_height = 0.5,
    },
    finder = finders.new_table {
      results = commits,
      entry_maker = gen_from_pr_commits(opts)
    },
    previewer = {
      -- previewers.git_commit_diff_to_parent.new(opts),
      changed_files_previewer
    },
    sorter = conf.generic_sorter(opts),
  }):find()
end

return M
