require("mason-lspconfig").setup {
  ensure_installed = {
    "ansiblels",
    "astro",
    "clangd",
    "elmls",
    "eslint",
    "gopls",
    "lua_ls",
    "pyright",
    "tailwindcss",
    "volar",
    "yamlls",
  },
  automatic_installation = false,
}
