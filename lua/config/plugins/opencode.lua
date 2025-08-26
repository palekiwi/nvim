return {
  {
    'NickvanDyke/opencode.nvim',
    dependencies = {
      -- Recommended for better prompt input, and required to use opencode.nvim's embedded terminal. Otherwise optional.
      { 'folke/snacks.nvim', opts = { input = { enabled = true } } },
    },
    ---@type opencode.Opts
    opts = {
      -- load port from an env var set on a project basis or use a custom default
      port = os.getenv("OPENCODE_PORT") and tonumber(os.getenv("OPENCODE_PORT")) or 49000,
    },
    keys = {
      -- Recommended keymaps
      { '<S-C-d>',    function() require('opencode').command('messages_half_page_down') end, desc = 'Scroll messages down', },
      { '<S-C-u>',    function() require('opencode').command('messages_half_page_up') end, desc = 'Scroll messages up', },
      { '<space>eA', function() require('opencode').ask() end, desc = 'Ask opencode', },
      { '<space>ea', function() require('opencode').ask('@cursor: ') end, desc = 'Ask opencode about this', mode = 'n', },
      { '<space>ea', function() require('opencode').ask('@selection: ') end, desc = 'Ask opencode about selection', mode = 'v', },
      { '<space>ee', function() require('opencode').prompt("Explain @cursor and its context") end, desc = "Explain code near cursor", },
      { '<space>en', function() require('opencode').command('session_new') end, desc = 'New session', },
      { '<space>ep', function() require('opencode').select_prompt() end, desc = 'Select prompt', mode = { 'n', 'v', }, },
      { '<space>ey', function() require('opencode').command('messages_copy') end, desc = 'Copy last message', },
    },
  }
}
