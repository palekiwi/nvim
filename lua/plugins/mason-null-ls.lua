require("mason-null-ls").setup {
  ensure_installed = {
    "golines",
    "sql-formatter",
  },
  automatic_installation = true,
}
