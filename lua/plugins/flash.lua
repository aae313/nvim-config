return {
  "folke/flash.nvim",
  opts = {
    label = {
      uppercase = false,
    },
  },
  keys = {
    { "<CR>", mode = "n", function() require("flash").jump() end, desc = "Flash" },
    { "s", mode = "n", false },
  },
}
