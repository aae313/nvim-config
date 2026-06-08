local function project_root()
  return LazyVim.root()
end

local function fff_root()
  vim.cmd.tcd(vim.fn.fnameescape(project_root()))
end

return {
  "dmtrKovalenko/fff.nvim",
  build = "nix run .#release",
  lazy = false,

  opts = {
    hl = {
      normal = "Normal",
      border = "FloatBorder",
      title = "Title",
    },

    debug = {
      enabled = false,
    },

    layout = {
      prompt_position = "top",
      flex = { size = 130, wrap = "bottom" },
    },
  },

  keys = {
    {
      "<leader>ff",
      function()
        require("fff").find_files_in_dir(project_root())
      end,
      desc = "FFF files (Root Dir)",
    },

    {
      "<leader>/",
      function()
        fff_root()
        require("fff").live_grep()
      end,
      desc = "FFF grep (Root Dir)",
    },

    {
      "<leader>fc",
      function()
        fff_root()
        require("fff").live_grep({
          query = vim.fn.expand("<cword>"),
        })
      end,
      desc = "Search current word",
    },
  },
}
