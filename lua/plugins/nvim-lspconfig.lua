local wk = require("which-key")

local lsp_flags = {
  debounce_text_changes = 150,
}

local function format()
  vim.lsp.buf.format { async = true }
end

local on_attach = function(_, bufnr)
  vim.keymap.set("n", "<C-h>", vim.lsp.buf.signature_help, {buffer = bufnr})
  vim.keymap.set("n", "<C-space>", vim.lsp.buf.hover, {buffer = bufnr})
  vim.keymap.set("n", "<leader>f", format, {buffer = bufnr, desc = "[LSP] format"})
  vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {buffer = bufnr, desc = "[LSP] rename"})
  vim.keymap.set("n", "<C-d>", "<cmd>Telescope diagnostics<cr>", {buffer = bufnr, desc = "[Diagnostic] list"})
  vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, {buffer = bufnr, desc = "[Diagnostic] next"})
  vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, {buffer = bufnr, desc = "[Diagnostic] prev"})
  vim.keymap.set("n", "<leader>df", vim.diagnostic.open_float, {buffer = bufnr, desc = "[Diagnostic] float"})
end

-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lspconfig = require('lspconfig')

lspconfig["ansiblels"].setup {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = lsp_flags,
}

lspconfig["astro"].setup {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = lsp_flags,
}

lspconfig["clangd"].setup {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = lsp_flags,
}

lspconfig["cssls"].setup {
  capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
}

lspconfig["elmls"].setup {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = lsp_flags,
}

lspconfig["eslint"].setup {
  on_attach = function(_, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
  capabilities = capabilities,
  flags = lsp_flags,
}

lspconfig["gopls"].setup {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = lsp_flags,
}

lspconfig["lua_ls"].setup {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = lsp_flags,
}

lspconfig["nixd"].setup {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = lsp_flags,
  settings = {
    nixd = {
      nixpkgs = {
        expr = "import <nixpkgs> { }",
      },
      formatting = {
        command = { "nixpkgs-fmt" },
      },
    },
  }
}
-- lspconfig["rust_analyzer"].setup {
--     on_attach = on_attach,
--     capabilities = capabilities,
--     flags = lsp_flags,
-- }

lspconfig["solargraph"].setup {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = lsp_flags,
}

lspconfig["stimulus_ls"].setup {}

lspconfig["ts_ls"].setup {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = lsp_flags,
}
lspconfig["volar"].setup {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = lsp_flags,
}
lspconfig["yamlls"].setup {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = lsp_flags,
}
