return {
  "folke/which-key.nvim",
  opts = {
    delay = 30,
    triggers = {
      { "<auto>", mode = "nixsoc" },
      { "m", mode = { "n", "v" } },
    },
    spec = {
      {
        mode = { "n", "v" },
        { "m", group = "surround" },
      },
    },
  },
}
