local rails_utils = require('rails-utils')
local builtin = require('telescope.builtin')

local set = vim.keymap.set

local function find_files(dirs)
  builtin.find_files({ search_dirs = dirs })
end

set("n", "<A-r>", rails_utils.find_template_render, { desc = "[Rails] Where is current view renedered?" })
set("n", "<A-t>", rails_utils.find_template, { desc = "[Rails] Find this template" })

set("n", "<leader>gt", rails_utils.find_template, { desc = "[Rails] Find this template" })
set("n", "<C-s>", rails_utils.alternate, { desc = "[Rails] Find Spec" })
set("n", "<C-l>", rails_utils.show_failure_details, { desc = "[RSpec] Details" })
set("n", "<leader>dd", rails_utils.show_diagnostics, { desc = "[Diagnostic] RSpec" })

set("n", "<leader>rp", function() rails_utils.run_tests({ scope = "pr" }) end, { desc = "[RSpec] Test PR" })
set("n", "<leader>rt", function() rails_utils.run_tests({ scope = "file" }) end, { desc = "[RSpec] Test file" })
set("n", "<leader>rs", "<cmd>RSpecLiveTestOnSave<cr>", { desc = "[RSpec] Activate test on save" })
set("n", "<leader>rc", "<cmd>RSpecLiveTestOnSaveCancel<cr>", { desc = "[RSpec] Cancel test on save" })

set("n", "<leader>sC", function() find_files({ "app/contracts" }) end, { desc = "Contracts" })
set("n", "<leader>sS", function() find_files({ "app/services" }) end, { desc = "Services" })
set("n", "<leader>sc", function() find_files({ "app/controllers" }) end, { desc = "Controllers" })
set("n", "<leader>se", function() find_files({ "webpack/src/components/elm" }) end, { desc = "Elm" })
set("n", "<leader>sp", function() find_files({ "app/presenters" }) end, { desc = "Presenters" })
set("n", "<leader>sr", function() find_files({ "app/services" }) end, { desc = "Services" })
set("n", "<leader>ss", function() find_files({ "spec/" }) end, { desc = "Specs" })
set("n", "<leader>st", function() find_files({ "webpack/src/controllers" }) end, { desc = "Stimulus" })
set("n", "<leader>sv", function() find_files({ "app/views" }) end, { desc = "Views" })
set("n", "<leader>sy", function() find_files({ "webpack/src/styles" }) end, { desc = "Styles" })
