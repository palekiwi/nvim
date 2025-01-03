local lsp_flags = {
  debounce_text_changes = 150,
}

local on_attach = function(_, bufnr)
  vim.keymap.set("n", "<C-h>", vim.lsp.buf.signature_help, { buffer = bufnr })
  vim.keymap.set("n", "<C-space>", vim.lsp.buf.hover, { buffer = bufnr })
  vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format { async = true } end,
    { buffer = bufnr, desc = "[LSP] format" })
  vim.keymap.set("n", "<leader>dr", vim.lsp.buf.rename, { buffer = bufnr, desc = "[LSP] rename" })
end


local ruby_lsp = "solargraph"

return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      --- Add additional capabilities supported by nvim-cmp
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
        capabilities = require('cmp_nvim_lsp').default_capabilities(
          vim.lsp.protocol.make_client_capabilities()
        )
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

      lspconfig['ocamllsp'].setup {}

      lspconfig[ruby_lsp].setup {
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
    end,
  }
}
