return {
  {
    'NickvanDyke/opencode.nvim',
    dependencies = {
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
      { '<space>a', function() require('opencode').ask() end, desc = 'Ask opencode', },
      { '<space>e', function() require('opencode').prompt("Explain @cursor and its context") end, desc = "Explain code near cursor", },
      { '<space>n', function() require('opencode').command('session_new') end, desc = 'New session', },
      { '<space>p', function() require('opencode').select_prompt() end, desc = 'Select prompt', mode = { 'n', 'v', }, },
      { '<space>s', function() require('opencode').ask('@selection: ') end, desc = 'Ask opencode about selection', mode = 'v', },
      { '<space>i', function() require('opencode').ask('@cursor: ') end, desc = 'Ask at cursor', mode = 'n', },
      { '<space>f', function() require('opencode').ask('@buffer: ') end, desc = 'Ask about buffer', mode = 'n', },
      { '<space>y', function() require('opencode').command('messages_copy') end, desc = 'Copy last message', },
    },
  }
}
