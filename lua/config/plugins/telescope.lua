return {
  {
    "nvim-telescope/telescope-ui-select.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
    },
    config = function()
      require("telescope").setup {
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {
            }
          }
        },
        defaults = {
          sorting_strategy = "ascending",
          layout_strategy = "vertical",
          layout_config = {
            vertical = {
              height = 0.9,
              mirror = true,
              prompt_position = "top",
              preview_cutoff = 0,
              preview_height = 0.5,
              width = 0.8
            }
          }
        }
      }
      --- To get ui-select loaded and working with telescope, you need to call
      --- load_extension, somewhere after setup function:
      require("telescope").load_extension("ui-select")
      require("telescope").load_extension("fzf")
    end,
  }
}
