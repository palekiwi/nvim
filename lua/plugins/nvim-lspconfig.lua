local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
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
