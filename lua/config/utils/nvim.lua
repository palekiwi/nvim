local M = {}

M.toggle_wrap = function()
  local wrap_status = vim.wo.wrap
  vim.wo.wrap = not wrap_status
end

return M
