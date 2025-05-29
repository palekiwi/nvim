local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local previewers = require "telescope.previewers"
local make_entry = require "telescope.make_entry"
local entry_display = require "telescope.pickers.entry_display"
local builtin = require 'telescope.builtin'
local utils = require('telescope.previewers.utils')

local git_utils = require('config.utils.git')
local gh_utils = require('config.utils.gh')

M = {}

local delta = previewers.new_termopen_previewer {
  get_command = function(entry)
    local base_branch = vim.g.git_base or "master"

    return { 'git', '--no-pager', 'diff', '--unified=0', base_branch .. '..HEAD', entry.value }
  end
}

local custom_file_diff_previewer = previewers.new_buffer_previewer({
  title = "File Diff",
  define_preview = function(self, entry, _status)
    local base_branch = vim.g.git_base or "master"

    local diff_output = vim.fn.system(
      "git --no-pager diff --color=never --unified=3 " .. base_branch .. '..HEAD ' .. entry.value
    )

    local lines = {}

    for line in diff_output:gmatch("[^\n]+") do
      if not line:match("^index ") and not line:match("^diff %-%-git ") and not line:match("^%-%-%- ") and not line:match("^%+%+%+ ") then
        table.insert(lines, line)
      end
    end

    vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
    utils.highlighter(self.state.bufnr, "diff")
  end,
})

local custom_diff_previewer = previewers.new_buffer_previewer({
  title = "Git Diff",
  define_preview = function(self, entry, _status)
    local commit_hash = entry.value:match("^(%w+)") ---@type string

    local diff_output = vim.fn.system(string.format(
      "git --no-pager show --color=never --unified=0 --format= %s",
      commit_hash
    ))

    local lines = {}
    local current_file = nil
    local first_file = true

    for line in diff_output:gmatch("[^\n]+") do
      if line:match("^diff %-%-git ") then
        -- Add spacing before each file (except the first one)
        if not first_file then
          table.insert(lines, "")
        end
        first_file = false

        -- Extract filename from diff --git a/file b/file
        current_file = line:match(" b/(.+)$")
        table.insert(lines, current_file)

        -- Skip index, ---, +++ lines, keep everything else
      elseif not line:match("^index ") and not line:match("^%-%-%- ") and not line:match("^%+%+%+ ") then
        table.insert(lines, line)
      end
    end

    vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
    utils.highlighter(self.state.bufnr, "diff")
  end,
})

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
    previewer = custom_file_diff_previewer,
    sorter = conf.generic_sorter(opts),
  }):find()
end

-- live grep in change files
M.grep_changed_files = function(opts)
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

  ---local files = vim.fn.systemlist("git diff --name-only " .. result)

  opts = opts or {}

  pickers.new(opts, {
    prompt_title = "changed files",
    finder = finders.new_table {
      results = files,
      entry_maker = make_entry.gen_from_file(opts)
    },
    previewer = custom_file_diff_previewer,
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

-- list "PR commits", i.e. commits that are present on current branch
-- but absent on the base branch
M.git_commits = function(opts)
  local base_branch = os.getenv("GIT_BASE")
  local args ---@type string

  if base_branch == nil then
    -- show only merge commits from pull requests
    args = "--merges --grep='Merge pull request'"
  else
    args = "HEAD ^" .. base_branch
  end

  local command = "git log --pretty=format:'%h %ai %<(20)%an %s' " .. args

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

      map('i', '<C-y>', function()
        local hash = action_state.get_selected_entry().value ---@type string
        vim.fn.setreg('+', hash)

        actions.close(prompt_bufnr)
      end)

      map('i', '<C-g>', function()
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

      map('i', '<C-u>', function()
        local msg = action_state.get_selected_entry().msg ---@type string
        gh_utils.copy_pr_url_from_message(msg)

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
        "git show --name-status --format='' %s",
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

  local changed_files_tree_previewer = previewers.new_buffer_previewer({
    title = "Changed Files",
    define_preview = function(self, entry, _status)
      local commit_hash = entry.value:match("^(%w+)") ---@type string

      -- Get file names with status
      local changed_files = vim.fn.system(string.format(
        "git show --name-status --format='' %s",
        commit_hash
      ))

      -- Define custom highlight group for renames
      vim.api.nvim_set_hl(0, 'GitFileRenamed', { fg = '#de935f', bold = true }) -- Orange/bold

      local function get_status_highlight(status)
        local highlights = {
          A = "GitSignsAdd",       -- Added (green)
          M = "GitSignsChange",    -- Modified (blue/yellow)
          D = "GitSignsDelete",    -- Deleted (red)
          ["R+"] = "GitFileRenamed", -- Renamed to (orange)
          ["R-"] = "GitFileRenamed", -- Renamed from (orange)
          T = "GitSignsChange",    -- Type changed (blue/yellow)
          U = "ErrorMsg",          -- Unmerged (red/error)
        }

        -- Handle rename statuses like "R063"
        if status:match("^R") then
          return "GitFileRenamed"
        end

        return highlights[status] or "Normal"
      end

      local function create_tree_structure(file_data)
        local tree = {}

        for _, data in ipairs(file_data) do
          if data.status:match("^R") and data.old_path and data.new_path then
            -- Handle renamed files - show both old and new paths
            local old_parts = vim.split(data.old_path, '/')
            local new_parts = vim.split(data.new_path, '/')

            -- Add old path (marked as deleted)
            local current = tree
            for i, part in ipairs(old_parts) do
              if i == #old_parts then
                current[part .. " [R-]"] = { status = "R-" }
              else
                if not current[part] then
                  current[part] = {}
                end
                current = current[part]
              end
            end

            -- Add new path (marked as added)
            current = tree
            for i, part in ipairs(new_parts) do
              if i == #new_parts then
                current[part .. " [R+]"] = { status = "R+" }
              else
                if not current[part] then
                  current[part] = {}
                end
                current = current[part]
              end
            end
          else
            -- Handle normal files
            local parts = vim.split(data.path, '/')
            local current = tree

            for i, part in ipairs(parts) do
              if i == #parts then
                -- Last part (filename) - store with status
                current[part .. " [" .. data.status .. "]"] = { status = data.status }
              else
                -- Directory part
                if not current[part] then
                  current[part] = {}
                end
                current = current[part]
              end
            end
          end
        end

        return tree
      end

      local function format_tree(tree, prefix, is_last, lines, highlights)
        lines = lines or {}
        highlights = highlights or {}
        local keys = vim.tbl_keys(tree)
        table.sort(keys)

        for i, key in ipairs(keys) do
          local is_last_item = (i == #keys)
          local connector = is_last_item and "└── " or "├── "
          local line_content = prefix .. connector .. key
          local line_number = #lines + 1

          table.insert(lines, line_content)

          -- Check if this is a file with status (has status field)
          if tree[key].status then
            local status = tree[key].status
            local highlight_group = get_status_highlight(status)

            -- Find the status bracket position
            local bracket_start = line_content:find("%[")
            if bracket_start then
              -- Highlight the entire line with the status color
              table.insert(highlights, {
                line = line_number,
                col_start = 0,
                col_end = #line_content,
                hl_group = highlight_group
              })

              -- Add extra highlighting for the status bracket
              table.insert(highlights, {
                line = line_number,
                col_start = bracket_start - 1,
                col_end = #line_content,
                hl_group = highlight_group
              })
            end
          else
            -- Directory - highlight with Directory color
            local dir_start = #(prefix .. connector)
            table.insert(highlights, {
              line = line_number,
              col_start = dir_start,
              col_end = #line_content,
              hl_group = "Directory"
            })
          end

          if next(tree[key]) and not tree[key].status then
            local new_prefix = prefix .. (is_last_item and "    " or "│   ")
            format_tree(tree[key], new_prefix, is_last_item, lines, highlights)
          end
        end

        return lines, highlights
      end

      -- Parse the git output to extract status and file paths
      local file_data = {}
      for line in changed_files:gmatch("[^\n]+") do
        if line ~= "" then
          local status = line:match("^(%w+)")
          if status:match("^R") then
            -- Handle renamed files: "R100    old/path.txt    new/path.txt"
            local old_path, new_path = line:match("^R%d*%s+(.-)%s+(.+)$")
            if old_path and new_path then
              table.insert(file_data, {
                status = status,
                old_path = old_path,
                new_path = new_path
              })
            end
          else
            -- Handle normal files: "M    path/to/file.txt"
            local filepath = line:match("^%w+%s+(.+)$")
            if filepath then
              table.insert(file_data, { status = status, path = filepath })
            end
          end
        end
      end

      local tree = create_tree_structure(file_data)
      local formatted_lines, highlights = format_tree(tree, "")

      -- Set the content
      vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, formatted_lines)

      -- Apply syntax highlighting
      vim.api.nvim_buf_set_option(self.state.bufnr, 'filetype', 'git')

      -- Apply custom highlights
      for _, hl in ipairs(highlights) do
        vim.api.nvim_buf_add_highlight(
          self.state.bufnr,
          -1,        -- namespace
          hl.hl_group,
          hl.line - 1, -- 0-indexed
          hl.col_start,
          hl.col_end
        )
      end
    end
  })

  pickers.new(opts, {
    prompt_title = "PR Commits",
    finder = finders.new_table {
      results = files,
      entry_maker = gen_from_git_commits(opts)
    },
    previewer = {
      -- previewers.git_commit_diff_to_parent.new(opts),
      custom_diff_previewer,
      -- changed_files_previewer,
      changed_files_tree_previewer,
    },
    sorter = conf.generic_sorter(opts),
  }):find()
end

return M
