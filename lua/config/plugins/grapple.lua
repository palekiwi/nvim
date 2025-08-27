return {
  {
    "cbochs/grapple.nvim",
    enabled = true,
    opts = {
      scope = "git_branch",
    },
    event = { "BufReadPost", "BufNewFile" },
    cmd = "Grapple",
    keys = {
      { "tt",         "<cmd>Grapple toggle<cr>",          desc = "Grapple toggle tag" },
      { "<C-t>",      "<cmd>Grapple toggle_tags<cr>",     desc = "Grapple open tags window" },
      { "<leader>fn", "<cmd>Grapple cycle_tags next<cr>", desc = "Grapple cycle next tag" },
      { "<leader>fp", "<cmd>Grapple cycle_tags prev<cr>", desc = "Grapple cycle previous tag" },
    },
  }, }
