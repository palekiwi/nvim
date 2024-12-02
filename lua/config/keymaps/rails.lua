local rails_utils = require('rails-utils')
local builtin = require('telescope.builtin')

local function find_files(dirs)
  builtin.find_files({ search_dirs = dirs })
end

return {
  { "<A-t>",      rails_utils.find_template_render,                            desc = "Find template in views" },
  { "<A-v>",      rails_utils.find_template,                                   desc = "Views" },
  { "<C-s>",      rails_utils.alternate,                                       desc = "Find Spec" },
  -- start group: search
  { "<leader>s",  group = "Search" },
  { "<leader>sC", function() find_files({ "app/contracts" }) end,              desc = "Contracts" },
  { "<leader>sS", function() find_files({ "app/services" }) end,               desc = "Services" },
  { "<leader>sc", function() find_files({ "app/controllers" }) end,            desc = "Controllers" },
  { "<leader>se", function() find_files({ "webpack/src/components/elm" }) end, desc = "Elm" },
  { "<leader>sp", function() find_files({ "app/presenters" }) end,             desc = "Presenters" },
  { "<leader>sr", function() find_files({ "app/services" }) end,               desc = "Services" },
  { "<leader>ss", function() find_files({ "spec/" }) end,                      desc = "Specs" },
  { "<leader>st", function() find_files({ "webpack/src/controllers" }) end,    desc = "Stimulus" },
  { "<leader>sv", function() find_files({ "app/views" }) end,                  desc = "Views" },
  { "<leader>sy", function() find_files({ "webpack/src/styles" }) end,         desc = "Styles" },
  { "<C-l>",  "<cmd>RSpecLineFail<cr>",                                    desc = "RSpec Line Details" },

  -- end group: search
}
