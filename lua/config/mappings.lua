local wk = require("which-key")
local kiwi = require('kiwi')
require("config.keymaps.rails")
local keymaps_telescope = require("config.keymaps.telescope")

local helpers = require('config.utils.helpers')
local telescope_utils = require('config.utils.telescope')
local gh_utils = require('config.utils.gh')
local git_utils = require('config.utils.git')
local nvim_utils = require('config.utils.nvim')

local set = vim.keymap.set

set({ 'n', 'v' }, '<Down>', 'gj')
set({ 'n', 'v' }, '<Up>', 'gk')

vim.api.nvim_set_keymap('v', '<C-C>', '"+y', { noremap = true, silent = true })

-- Set the default step size to 5
vim.keymap.set('n', '<C-w>m', '40<C-w>>', { noremap = true })
vim.keymap.set('n', '<C-w>M', '40<C-w><', { noremap = true })

local base = {
  { "<A-,>",        "<cmd>BufferPrevious<cr>",                                              desc = "Previous Buffer" },
  { "<A-.>",        "<cmd>BufferNext<cr>",                                                  desc = "Next Buffer" },
  { "<A-<>",        "<cmd>BufferMovePrevious<cr>",                                          desc = "Move Previous Buffer" },
  { "<A->>",        "<cmd>BufferMoveNext<cr>",                                              desc = "Move Next Buffer" },
  { "<A-X>",        "<cmd>BufferCloseAllButCurrent<cr>",                                    desc = "Close Buffer All But Current" },
  { "<A-f>",        "<cmd>Telescope live_grep<cr>",                                         desc = "Live Grep" },
  { "<A-Left>",     "<cmd>cfirst<cr>",                                                      desc = "[Qflist] First" },
  { "<A-Up>",       "<cmd>cprev<cr>",                                                       desc = "[Qflist] Prev" },
  { "<A-Down>",     "<cmd>cnext<cr>",                                                       desc = "[Qflist] Next" },
  { "<A-PageUp>",   "<cmd>lprev<cr>",                                                       desc = "[Loclist] Prev" },
  { "<A-PageDown>", "<cmd>lnext<cr>",                                                       desc = "[Loclist] Next" },
  { "<space>eg",    telescope_utils.git_commits,                                            desc = "[Telescope] Branch commits" },
  { "<space>es",    "<cmd>Telescope current_buffer_tags show_line=true<cr>",                desc = "Tags" },
  { "<space>eh",    "<cmd>Telescope help_tags<cr>",                                         desc = "Help tags" },
  { "<space>et",    telescope_utils.search_tags,                                            desc = "Search tags" },
  { "<space>ep",    telescope_utils.grep_changed_files,                                     desc = "Live Grep in changed files" },
  { "<space>ge",    "<cmd>Telescope grep_string word_match=-w<cr>",                         desc = "String Grep" },
  { "<space>t",     git_utils.changed_files_to_loclist,                                     desc = "Change to loclist" },
  { "<space>m",     "<cmd>Himalaya<cr>",                                                    desc = "Himalaya" },
  { "<A-l>",        "<cmd>set cursorline!<cr>",                                             desc = "Toggle Cursorline" },
  { "<A-m>",        "zMzA",                                                                 desc = "Toggle Fold" },
  { "<A-u>",        "<Plug>CapsLockToggle",                                                 desc = "Toggle Capslock",                   mode = "i" },
  { "<A-w>",        telescope_utils.search_cword,                                           desc = "Live Grep" },
  { "<A-x>",        "<cmd>BufferClose<cr>",                                                 desc = "Close Buffer All But Current" },
  { "<A-z>",        "za",                                                                   desc = "Toggle Fold" },
  { "<C-b>",        "<cmd>Telescope buffers ignore_current_buffer=false sort_mru=true<cr>", desc = "Buffers" },
  { "<C-d>",        "<cmd>Telescope diagnostics<cr>",                                       desc = "[LSP] diagnostics" },
  { "<C-e>",        "<cmd>Telescope oldfiles cwd_only=true<cr>",                            desc = "Recent Files" },
  { "<leader>fe",   "<cmd>b#<cr>",                                                          desc = "Last Buffer" },
  { "<C-f>",        "<cmd>Telescope find_files<cr>",                                        desc = "Find File" },
  { "<C-p>",        telescope_utils.changed_files,                                          desc = "Search changed files" },
  { "<A-p>",        telescope_utils.changed_files_since,                                    desc = "Search changed files" },
  { "<A-d>",        telescope_utils.diffview_since,                                         desc = "Search changed files" },
  { "<C-q>",        "<cmd>Telescope quickfix show_line=false<cr>",                          desc = "Quickfix" },
  { "<C-t>",        telescope_utils.search_tags_cword,                                      desc = "Find tag" },
  { "<C-u>",        telescope_utils.lsp_references,                                         desc = "Ref" },
  { "<Esc><Esc>",   "<C-\\><C-n>",                                                          desc = "Exit termina mode",                 mode = "t" },
  { "<F4>",         "<C-R>=strftime('%T')<cr>",                                             desc = "Insert time",                       mode = "i" },
  { "<F5>",         "<C-R>=strftime('%Y-%m-%d %a')<cr>",                                    desc = "Insert date with weekday",          mode = "i" },
  { "<F6>",         "<C-R>=strftime('%F')<cr>",                                             desc = "Insert date",                       mode = "i" },
  { "<F8>",         "<C-R>=expand('%:t')<cr>",                                              desc = "Insert current filename",           mode = "i" },
  { "<leader>c",    "<cmd>let @+=fnamemodify(expand('%'), ':~:.')<cr>",                     desc = "copy current filepath to clipboard" },
  { "<leader>gr",   "<cmd>Gitsigns reset_hunk<cr>",                                         desc = "[Gitsigns] Reset Hunk" },
  { "<leader>gs",   "<cmd>Gitsigns show<cr>",                                               desc = "[Gitsigns] Show" },
  { "<leader>h",    "<cmd>Gitsigns toggle_deleted<cr><cmd>Gitsigns toggle_word_diff<cr>",   desc = "Git: Preview inline" },
  { "<leader>n",    function() git_utils.toggle_git_tree("focus") end,                      desc = "Tree: Git status" },
  { "<leader>N",    function() git_utils.toggle_git_tree("show") end,                       desc = "Tree: Git status" },
  { "<leader>q",    "<cmd>quit<cr>",                                                        desc = "quit" },
  { "<leader>t",    "<cmd>Neotree toggle position=left<cr>",                                desc = "tree toggle" },
  { "<leader>b",    "<cmd>Neotree toggle show buffers left<cr>",                            desc = "tree toggle" },
  { "<leader>w",    "<cmd>write<cr>",                                                       desc = "write" },
  { "<space>a",     vim.lsp.buf.code_action,                                                desc = "LSP Code Action" },
  { "<space>l",     helpers.open_on_line,                                                   desc = "Open file on line" },
  { "<space>h",     "<cmd>hide<cr>",                                                        desc = "Hide" },
  { "<space>n",     "<cmd>only<cr>",                                                        desc = "Only" },
  { "<space>o",     helpers.toggle_quickfix,                                                desc = "Toggle quickfix" },
  { "<space>q",     "<cmd>quit<cr>",                                                        desc = "Quit" },
  { "<space>u",     "<cmd>%s/fit/it<cr>",                                                   desc = "Unfocus test in Ruby" },
  { "<space>w",     nvim_utils.toggle_wrap,                                                 desc = "Toggle Wrap" },
  { "<space>x",     "<cmd>quit<cr>",                                                        desc = "Quit" },
  { "<space>y",     "<cmd>%y+<cr>",                                                         desc = "Copy contents to clipboard" },
  { "H",            git_utils.prev_hunk,                                                    desc = "Prev hunk" },
  { "T",            kiwi.todo.toggle,                                                       desc = "Toggle Todo" },
  { "W",            "<cmd>HopWord<cr>",                                                     desc = "Hop Word",                          mode = "n" },
  { "g",            group = "go to" },
  { "gc",           vim.lsp.buf.declaration,                                                desc = "[LSP] Go to Declaration" },
  { "gd",           vim.lsp.buf.definition,                                                 desc = "[LSP] Go to Definition" },
  { "gi",           vim.lsp.buf.implementation,                                             desc = "[LSP] Go to Implementation" },
  { "gr",           vim.lsp.buf.references,                                                 desc = "[LSP] Go to References" },
  { "gt",           vim.lsp.buf.type_definition,                                            desc = "[LSP] Go to Type Definition" },
  { "h",            git_utils.next_hunk,                                                    desc = "Next hunk" },
  { "l",            "<cmd>HopLineStart<cr>",                                                desc = "Hop Line Start",                    mode = { "n", "v" } },
  { "s",            "<cmd>HopChar1<cr>",                                                    desc = "Hop Char 1",                        mode = { "n", "v" } },
  -- toggle
  { "t",            group = "toggle" },
  { "t0",           function() git_utils.set_base_branch("HEAD") end,                       desc = "Change base: HEAD~1" },
  { "t1",           function() git_utils.set_base_branch("HEAD~1") end,                     desc = "Change base: HEAD~1" },
  { "t2",           function() git_utils.set_base_branch("HEAD~2") end,                     desc = "Change base: HEAD~2" },
  { "tb",           "<cmd>Gitsigns toggle_current_line_blame<cr>",                          desc = "Blame" },
  { "te",           function() git_utils.set_base_branch(os.getenv("GIT_BASE")) end,        desc = "Change base: From Environment" },
  { "tf",           "<cmd>Neotree float git_status<cr>",                                    desc = "Float git status" },
  { "th",           "<cmd>Gitsigns preview_hunk_inline<cr>",                                desc = "Deleted" },
  { "tm",           function() git_utils.set_base_branch("master") end,                     desc = "Change base: master" },
  { "tn",           function() git_utils.diffthis(true) end,                                desc = "Diff this: vertical" },
  { "tN",           "<cmd>DiffviewOpen<cr>",                                                desc = "DiffviewOpen" },
  { "tq",           git_utils.hunks_to_loclist,                                             desc = "Hunks to Loclist" },
  { "tl",           "<cmd>nohlsearch<cr>",                                                  desc = "Hunks to Loclist" },
  { "ti",           git_utils.diffview_this,                                                desc = "Diff this: horizontal" },
  { "tI",           "<cmd>DiffviewClose<cr>",                                               desc = "DiffviewClose" },
  { "<leader>y",    group = "Copy to clipboard" },
  { "<leader>yb",   function() gh_utils.copy_file_url({ branch = vim.g.git_base }) end,     desc = "GH file: base" },
  { "<leader>yc",   gh_utils.copy_files_changed_url,                                        desc = "GH files changed" },
  { "<leader>yd",   gh_utils.copy_diff_url,                                                 desc = "GH diff" },
  { "<leader>yf",   gh_utils.copy_file_url,                                                 desc = "GH file: current" },
  { "<leader>yh",   gh_utils.copy_blame_hash_short,                                         desc = "GH file: short hash" },
  { "<leader>ym",   function() gh_utils.copy_file_url({ branch = "master" }) end,           desc = "GH file: master" },
  { "<leader>yp",   function() gh_utils.copy_file_url({ branch = vim.fn.getreg("+") }) end, desc = "GH file: clipboard" },
  { "<leader>li",   "<cmd>LspInfo<cr>",                                                     desc = "LSP: Info" },
  { "<leader>ll",   "<cmd>LspLog<cr>",                                                      desc = "LSP: Log" },
  { "<leader>lr",   "<cmd>LspRestart<cr>",                                                  desc = "LSP: Restart" },
}

set("n", "<leader>dn", vim.diagnostic.goto_next, { desc = "[Diagnostic] next" })
set("n", "<leader>dp", vim.diagnostic.goto_prev, { desc = "[Diagnostic] prev" })
set("n", "<leader>df", vim.diagnostic.open_float, { desc = "[Diagnostic] float" })

set("n", "<leader>x", "<cmd>.lua<CR>", { desc = "Execute the current line" })
set("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "Execute the current file" })

local noop = {
  { "s", "s", desc = "No Op", mode = "s" }, -- prevent changing mode in snippet expansion
  { "l", "l", desc = "No Op", mode = "s" }, -- prevent changing mode in snippet expansion
}

wk.add(base)
wk.add(noop)

wk.add(keymaps_telescope)

wk.setup({})
