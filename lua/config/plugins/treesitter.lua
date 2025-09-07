return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',
    config = function()
      -- Your language list
      local languages = {
        "vimdoc", "bash", "ini", "json", "yaml", "git_config", "gitignore",
        "sxhkdrc", "c", "cmake", "rust", "toml", "lua", "python",
        "javascript", "typescript", "html", "css", "astro", "dockerfile",
        "go", "ruby", "vue", "nu", "nix"
      }

      require('nvim-treesitter').setup({
        install_dir = vim.fn.stdpath('data') .. '/site'
      })

      require('nvim-treesitter').install(languages)
    end,
  }
}
