local builtin = require('telescope.builtin')

local function find_in_config()
  local opts = require('telescope.themes').get_ivy({
    cwd = vim.fn.stdpath("config")
  })
  builtin.find_files(opts)
end

return {
  { "<space>ed", find_in_config, desc = "[Telescope] Find in config" },
}
