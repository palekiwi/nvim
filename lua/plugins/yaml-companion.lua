require("telescope").load_extension("yaml_schema")

local cfg = require("yaml-companion").setup({})

require("lspconfig")["yamlls"].setup(cfg)
