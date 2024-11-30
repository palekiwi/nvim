local create_autocmd = vim.api.nvim_create_autocmd

local function set_git_base(varname)
  create_autocmd("VimEnter", {
    callback = function()
      local base_branch = os.getenv(varname) or "master"
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

end
