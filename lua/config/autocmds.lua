vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local root = require("lazyvim.util").root()
    if root then
      vim.cmd.lcd(vim.fn.fnameescape(root))
    end
  end,
})
