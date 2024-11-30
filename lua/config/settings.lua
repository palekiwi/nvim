-- Ansible managed: templates/lua/config/settings.lua.j2 modified on 2023-07-20 19:06:46 by pl on dev.ctn
local set = vim.opt

set.termguicolors = true

set.title = true
set.titlestring = "[vim] %t (%{expand('%:p:h')})"

vim.notify = require("notify")

set.expandtab = true
set.smarttab = true
set.shiftwidth = 4
set.tabstop = 4

set.hlsearch = true
set.incsearch = true
set.ignorecase = true
set.smartcase = true

set.splitbelow = true
set.splitright = true
set.wrap = false
set.scrolloff = 5
set.fileencoding = 'utf-8'

set.number = true
set.relativenumber = false
set.cursorline = false

set.laststatus = 3

set.timeout = true
set.timeoutlen = 300

set.hidden = true
set.completeopt = 'menuone,noselect'

set.foldlevel = 1
set.foldmethod = "indent"
set.foldexpr = "nvim_treesitter#foldexpr()"

vim.api.nvim_set_option("clipboard", "unnamed")

vim.api.nvim_create_autocmd({ "BufRead" }, {
  pattern = { "*" },
  command = "set foldlevel=99",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "php",
  command = "setlocal autoindent"
})

vim.diagnostic.config({
  virtual_text = false
})

vim.filetype.add({
  pattern = {
    ['.*/playbooks?/.*.ya?ml'] = 'yaml.ansible',
    ['.*/roles/.*.ya?ml'] = 'yaml.ansible',
    ['.*/handlers/.*.ya?ml'] = 'yaml.ansible',
    ['.*/tasks/.*.ya?ml'] = 'yaml.ansible',
    ['.*/molecule/.*.ya?ml'] = 'yaml.ansible',
    ['.*/host_vars/.*.ya?ml'] = 'yaml.ansible',
    ['.*/group_vars/.*.ya?ml'] = 'yaml.ansible',
    ['.*.lua.j2'] = 'lua.j2',
    ['.*.service.j2'] = 'systemd.j2',
    ['.*.timer.j2'] = 'systemd.j2',
    ['.*.hujson'] = 'hjson',
    ['.*.gohtml'] = 'html',
    ['.*.jet'] = 'html',
    ['.*go.mod'] = 'gomod',
    ['.*.bu'] = 'yaml',
    ['.*.ya?ml.j2'] = 'yaml.j2',
    ['.*.dbml'] = 'dbml',
  },
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*/files/*.yml", "*/k8s/*.yml" },
  command = "setlocal filetype=yaml",
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local base_branch = os.getenv("GIT_BASE") or "master"
    vim.g.git_base = base_branch
    require("gitsigns").change_base(base_branch, true)
  end,
})

local color = vim.api.nvim_get_hl(0, { name = 'Constant' })
vim.api.nvim_set_hl(0, "@stimulus-controller.html", { fg = color.fg, bold = true })
vim.api.nvim_set_hl(0, "@stimulus-attribute.html", { fg = color.fg, bold = false })
