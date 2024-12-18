local wk = require("which-key")
local kiwi = require('kiwi')
local keymaps_rails = require("config.keymaps.rails")
local keymaps_telescope = require("config.keymaps.telescope")

local helpers = require('config.utils.helpers')
local telescope_utils = require('config.utils.telescope')
local gh_utils = require('config.utils.gh')
local git_utils = require('config.utils.git')

vim.g.mapleader = ","

vim.keymap.set({ 'n', 'v' }, '<Down>', 'gj')
vim.keymap.set({ 'n', 'v' }, '<Up>', 'gk')

vim.api.nvim_set_keymap('v', '<C-C>', '"+y', { noremap = true, silent = true })

local base = {
  { "<A-,>",      "<cmd>BufferPrevious<cr>",                                              desc = "Previous Buffer" },
  { "<A-.>",      "<cmd>BufferNext<cr>",                                                  desc = "Next Buffer" },
  { "<A-<>",      "<cmd>BufferMovePrevious<cr>",                                          desc = "Move Previous Buffer" },
  { "<A->>",      "<cmd>BufferMoveNext<cr>",                                              desc = "Move Next Buffer" },
  { "<A-X>",      "<cmd>BufferCloseAllButCurrent<cr>",                                    desc = "Close Buffer All But Current" },
  { "<A-c>",      gh_utils.copy_file_url,                                                 desc = "Copy gh file url" },
  { "<A-d>",      gh_utils.copy_diff_url,                                                 desc = "Copy gh diff url" },
  { "<A-d>",      gh_utils.copy_files_changed_url,                                        desc = "Copy gh diff url" },
  { "<A-f>",      "<cmd>Telescope live_grep<cr>",                                         desc = "Live Grep" },
  { "<A-g>",      telescope_utils.git_commits,                                            desc = "Find template in views" },
  { "<A-h>",      "<cmd>Telescope help_tags<cr>",                                         desc = "Help tags" },
  { "<A-l>",      "<cmd>set cursorline!<cr>",                                             desc = "Toggle Cursorline" },
  { "<A-m>",      "zMzA",                                                                 desc = "Toggle Fold" },
  { "<A-n>",      "<Plug>CapsLockToggle",                                                 desc = "Toggle Capslock",                   mode = "i" },
  { "<A-s>",      "<cmd>Telescope current_buffer_tags show_line=true<cr>",                desc = "Tags" },
  { "<A-t>",      "<Cmd>FloatermToggle first<CR>",                                        desc = "Toggle first terminal" },
  { "<A-w>",      "<cmd>Telescope grep_string word_match=-w<cr>",                         desc = "String Grep" },
  { "<A-x>",      "<cmd>BufferClose<cr>",                                                 desc = "Close Buffer All But Current" },
  { "<A-z>",      "za",                                                                   desc = "Toggle Fold" },
  { "<C-b>",      "<cmd>Telescope buffers ignore_current_buffer=true sort_mru=true<cr>",  desc = "Buffers" },
  { "<C-d>",      "<cmd>Telescope diagnostics<cr>",                                       desc = "[LSP] diagnostics" },
  { "<C-e>",      "<cmd>Telescope oldfiles cwd_only=true<cr>",                            desc = "Recent Files" },
  { "<C-f>",      "<cmd>Telescope find_files<cr>",                                        desc = "Find File" },
  { "<C-p>",      telescope_utils.changed_files,                                          desc = "Search changed files" },
  { "<C-q>",      "<cmd>Telescope quickfix show_line=false<cr>",                          desc = "Quickfix" },
  { "<C-t>",      telescope_utils.search_tags,                                            desc = "Find tag" },
  { "<C-u>",      telescope_utils.lsp_references,                                         desc = "Ref" },
  { "<Esc>",      "<C-\\><C-n>:q<CR>",                                                    desc = "Close floatterm",                   mode = "t" },
  { "<F4>",       "<C-R>=strftime('%T')<cr>",                                             desc = "Insert time",                       mode = "i" },
  { "<F5>",       "<C-R>=strftime('%Y-%m-%d %a')<cr>",                                    desc = "Insert date with weekday",          mode = "i" },
  { "<F6>",       "<C-R>=strftime('%F')<cr>",                                             desc = "Insert date",                       mode = "i" },
  { "<F8>",       "<C-R>=expand('%:t')<cr>",                                              desc = "Insert current filename",           mode = "i" },
  { "<leader>c",  "<cmd>let @+=expand('%')<cr>",                                          desc = "copy current filepath to clipboard" },
  { "<leader>gy", "<cmd>Telescope grep_string search_dirs=webpack/src/styles<cr>",        desc = "Grep Styles" },
  { "<leader>h",  "<cmd>Gitsigns toggle_deleted<cr>",                                     desc = "Deleted" },
  { "<leader>n",  git_utils.toggle_git_tree,                                              desc = "Tree: Git status" },
  { "<leader>q",  "<cmd>quit<cr>",                                                        desc = "quit" },
  { "<leader>t",  "<cmd>Neotree toggle position=left<cr>",                                desc = "tree toggle" },
  { "<leader>v",  function() kiwi.open_wiki_index() end,                                  desc = "Open wiki index" },
  { "<leader>w",  "<cmd>write<cr>",                                                       desc = "write" },
  { "<leader>x",  "<cmd>quit<cr>",                                                        desc = "quit" },
  { "<space>a",   vim.lsp.buf.code_action,                                                desc = "LSP Code Action" },
  { "<space>l",   helpers.open_on_line,                                                   desc = "Open file on line" },
  { "<space>h",   "<cmd>hide<cr>",                                                        desc = "Hide" },
  { "<space>n",   "<cmd>only<cr>",                                                        desc = "Only" },
  { "<space>o",   helpers.toggle_quickfix,                                                desc = "Toggle quickfix" },
  { "<space>q",   "<cmd>quit<cr>",                                                        desc = "Quit" },
  { "<space>u",   "<cmd>%s/fit/it<cr>",                                                   desc = "Unfocus test in Ruby" },
  { "<space>w",   "<cmd>write<cr>",                                                       desc = "Write" },
  { "<space>x",   "<cmd>quit<cr>",                                                        desc = "Quit" },
  { "<space>y",   "<cmd>%y+<cr>",                                                         desc = "Copy contents to clipboard" },
  { "H",          git_utils.prev_hunk,                                                    desc = "Prev hunk" },
  { "T",          kiwi.todo.toggle,                                                       desc = "Toggle Todo" },
  { "W",          "<cmd>HopWord<cr>",                                                     desc = "Hop Word",                          mode = "n" },
  { "g",          group = "go to" },
  { "gc",         vim.lsp.buf.declaration,                                                desc = "[LSP] Go to Declaration" },
  { "gd",         vim.lsp.buf.definition,                                                 desc = "[LSP] Go to Definition" },
  { "gi",         vim.lsp.buf.implementation,                                             desc = "[LSP] Go to Implementation" },
  { "gr",         vim.lsp.buf.references,                                                 desc = "[LSP] Go to References" },
  { "gt",         vim.lsp.buf.type_definition,                                            desc = "[LSP] Go to Type Definition" },
  { "h",          git_utils.next_hunk,                                                    desc = "Next hunk" },
  { "l",          "<cmd>HopLineStart<cr>",                                                desc = "Hop Line Start",                    mode = { "n", "v" } },
  { "s",          "<cmd>HopChar1<cr>",                                                    desc = "Hop Char 1",                        mode = { "n", "v" } },
  -- toggle
  { "t",          group = "toggle" },
  { "t0",         function() git_utils.set_base_branch("HEAD") end,                       desc = "Change base: HEAD~1" },
  { "t1",         function() git_utils.set_base_branch("HEAD~1") end,                     desc = "Change base: HEAD~1" },
  { "t2",         function() git_utils.set_base_branch("HEAD~2") end,                     desc = "Change base: HEAD~2" },
  { "tb",         "<cmd>Gitsigns toggle_current_line_blame<cr>",                          desc = "Blame" },
  { "te",         function() git_utils.set_base_branch(os.getenv("GIT_BASE")) end,        desc = "Change base: From Environment" },
  { "tf",         "<cmd>Neotree float git_status<cr>",                                    desc = "Float git status" },
  { "th",         "<cmd>Gitsigns toggle_deleted<cr><cmd>Gitsigns toggle_word_diff<cr>",   desc = "Deleted" },
  { "tm",         function() git_utils.set_base_branch("master") end,                     desc = "Change base: master" },
  { "tn",         git_utils.diffthis,                                                     desc = "Diff this" },
  { "tq",         git_utils.hunks_to_loclist,                                             desc = "Hunks to Loclist" },
  { "tl",         "<cmd>nohlsearch<cr>",                                                  desc = "Hunks to Loclist" },
  { "<leader>y",  group = "Copy to clipboard" },
  { "<leader>yc", gh_utils.copy_files_changed_url,                                        desc = "GH files changed" },
  { "<leader>yd", gh_utils.copy_diff_url,                                                 desc = "GH diff" },
  { "<leader>yf", gh_utils.copy_file_url,                                                 desc = "GH file: current" },
  { "<leader>ym", function() gh_utils.copy_file_url({ branch = "master" }) end,           desc = "GH file: master" },
  { "<leader>yp", function() gh_utils.copy_file_url({ branch = vim.fn.getreg("+") }) end, desc = "GH file: clipboard" },
  { "<leader>yb", function() gh_utils.copy_file_url({ branch = vim.g.git_base }) end,     desc = "GH file: base" },
}

local noop = {
  { "s", "s", desc = "No Op", mode = "s" }, -- prevent changing mode in snippet expansion
  { "l", "l", desc = "No Op", mode = "s" }, -- prevent changing mode in snippet expansion
}

wk.add(base)
wk.add(noop)

wk.add(keymaps_telescope)

wk.setup({})

--- mappings only for a rails project
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.filereadable("bin/rails") == 1 then
      wk.add(keymaps_rails)
    end
  end,
})
