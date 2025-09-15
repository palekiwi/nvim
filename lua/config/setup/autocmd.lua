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

--- Sets PR number on startup 
--- @param name string name of an environmental variable that holds the branch name
local function set_pr_number(name)
  create_autocmd("VimEnter", {
    callback = function()
      local pr_number = os.getenv(name)
      if not pr_number then
        return
      else
        vim.g.gh_pr_number = pr_number
      end
    end,
  })
end


return function()
  set_git_base("GIT_BASE")
  set_pr_number("GH_PR_NUMBER")

  create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*/files/*.yml", "*/k8s/*.yml" },
    command = "setlocal filetype=yaml",
  })

  create_autocmd({ "BufRead" }, {
    pattern = { "*" },
    command = "set foldlevel=99",
  })

  create_autocmd("VimEnter", {
    callback = function()
      --- if launched in a rails project directory
      if vim.fn.filereadable("bin/rails") == 1 then
        --- mappings only for a rails project
        require("config.keymaps.rails")
      end
    end,
  })

end
