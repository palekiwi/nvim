return {
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup {
        ensure_installed = {
          "ansiblels",
          "astro",
          "clangd",
          "elmls",
          "eslint",
          "gopls",
          "pyright",
          "tailwindcss",
          "volar",
          "yamlls",
        },
        automatic_installation = false,
      }
    end,
  }
}
