local create_autocmd = vim.api.nvim_create_autocmd

--- Sets git base name on startup 
--- @param name? string name of an environmental variable that holds the branch name
local function set_git_base(name)
  create_autocmd("VimEnter", {
    callback = function()
      local base_branch = name and os.getenv(name) or "master"
      vim.g.git_base = base_branch
      require("gitsigns").change_base(base_branch, true)
    end,
  })
end

return function()
  set_git_base("GIT_BASE")

  create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*/files/*.yml", "*/k8s/*.yml" },
    command = "setlocal filetype=yaml",
  })

  create_autocmd({ "BufRead" }, {
    pattern = { "*" },
    command = "set foldlevel=99",
  })


  vim.api.nvim_create_user_command("AutoRun", function()
    print "AutoRun start now..."
    local bufnr = vim.fn.input "Bufnr: "
    print("\nchose:", bufnr)
  end, {})
end
