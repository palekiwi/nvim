--- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", --- latest stable release
    lazypath,
  })

  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

--- put lazy into the runtimepath for neovim
vim.opt.rtp:prepend(lazypath)

--- leader must be set befor calling lazy.setup
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"


--- lazy setup
--- @type LazyConfig
local opt = {
  dev = {
    fallback = false,
    path = "~/code/neovim/plugins/",
    patterns = {}
  },
  spec = {
    { import = "config.plugins" },
  }
}

require("lazy").setup(opt)