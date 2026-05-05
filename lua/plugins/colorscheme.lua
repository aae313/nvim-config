return {

  {
    "miikanissi/modus-themes.nvim",
    lazy = false,
    dim_inactive = true,
    opts = {
      style = "auto",
      dim_inactive = true,
      variants = {
        modus_operandi = "default", -- Set variant for `modus_operandi` style
        modus_vivendi = "default", -- Set variant for `modus_vivendi` style
      },
      on_highlights = function(hl, c)
        hl["@character.printf"] = { fg = c.cyan_warmer }
        hl["@lsp.typemod.function.defaultlibrary"] = { fg = c.indigo }
        hl["@lsp.type.parameter.c"] = { fg = c.fg_alt }
        hl["@keyword.directive.c"] = { fg = "#ffbd5e" }
        hl["@keyword.directive.define.c"] = { fg = "#ffbd5e" }
        hl["@keyword.import.c"] = { fg = "#ffbd5e" }
        hl.YankyPut = { link = "Search" }
        hl.YankyYanked = { bg = c.yellow_intense, fg = c.bg_main }
      end,
    },
  },

  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha",
      show_end_of_buffer = true,
      dim_inactive = {
        enabled = true,
        shade = "dark",
        percentage = 0.30,
      },
      lsp_styles = {
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
      },
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        dashboard = true,
        flash = true,
        fzf = true,
        grug_far = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        mason = true,
        mini = true,
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        snacks = true,
        telescope = true,
        treesitter_context = true,
        which_key = true,
      },
    },
    specs = {
      {
        "akinsho/bufferline.nvim",
        optional = true,
        opts = function(_, opts)
          if (vim.g.colors_name or ""):find("catppuccin") then
            opts.highlights = require("catppuccin.special.bufferline").get_theme()
          end
        end,
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "modus",
    },
  },
}
