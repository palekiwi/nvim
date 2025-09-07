return {
  {
    "palekiwi/rails-utils.nvim",
    dev = true,
    branch = "dev",
    config = function()
      require 'rails-utils'.setup({
        command = {
          "docker",
          "exec",
          "spabreaks-test-1",
          "bin/rspec",
          "--format",
          "j"
        },
      })
    end,
  }
}
