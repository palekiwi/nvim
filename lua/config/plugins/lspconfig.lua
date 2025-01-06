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

local function ruby_lsp_server()
  local cwd = vim.fn.getcwd()

  if  cwd == '/var/home/pl/code/ygt/wss-data' then
    return 'sorbet'
  else
    return 'solargraph'
  end
end

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

      local lsp_server = ruby_lsp_server()

      if lsp_server == "sorbet" then
        lspconfig["sorbet"].setup {
          on_attach = on_attach,
          capabilities = capabilities,
          flags = lsp_flags,
        }
      elseif lsp_server == "solargraph" then
        print "Setting up solargraph"

        lspconfig["solargraph"].setup {
          settings = {
            useBundler = false
          },
          on_attach = on_attach,
          capabilities = capabilities,
          flags = lsp_flags,
        }
      elseif lsp_server == "ruby-lsp" then
        vim.fn.system('go-task -a | grep "* ruby-lsp:"')

        if vim.v.shell_error == 0 then
          print "Setting up ruby-lsp via Docker"
          lspconfig["ruby_lsp"].setup {
            cmd = { "go-task", "ruby-lsp" },
            on_attach = on_attach,
            capabilities = capabilities,
            flags = lsp_flags,
          }
        else
          error "ruby-lsp not available"
        end
      end

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
