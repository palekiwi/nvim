local rails_utils = require('rails-utils')

return {
  { "<A-t>",      rails_utils.find_template_render,                                       desc = "Find template in views" },
  { "<A-v>",      rails_utils.find_template,                                              desc = "Views" },
  { "<C-s>",      rails_utils.alternate,                                                  desc = "Find Spec" },
  -- start group: search
  { "<leader>s",  group = "Search" },
  { "<leader>sC", "<cmd>Telescope find_files search_dirs=app/contracts<cr>",              desc = "Contracts" },
  { "<leader>sS", "<cmd>Telescope find_files search_dirs=app/services<cr>",               desc = "Services" },
  { "<leader>sc", "<cmd>Telescope find_files search_dirs=app/controllers<cr>",            desc = "Controllers" },
  { "<leader>se", "<cmd>Telescope find_files search_dirs=webpack/src/components/elm<cr>", desc = "Elm" },
  { "<leader>sp", "<cmd>Telescope find_files search_dirs=app/presenters<cr>",             desc = "Presenters" },
  { "<leader>sr", "<cmd>Telescope find_files search_dirs=app/services<cr>",               desc = "Services" },
  { "<leader>ss", "<cmd>Telescope find_files search_dirs=spec/<cr>",                      desc = "Specs" },
  { "<leader>st", "<cmd>Telescope find_files search_dirs=webpack/src/controllers<cr>",    desc = "Stimulus" },
  { "<leader>sv", "<cmd>Telescope find_files search_dirs=app/views<cr>",                  desc = "Views" },
  { "<leader>sy", "<cmd>Telescope find_files search_dirs=webpack/src/styles<cr>",         desc = "Styles" },
  -- end group: search
}
