local opt = vim.opt
vim.filetype.add({
  extension = {
    ct = "c",
  },
})

vim.o.modeline = false
vim.o.modelines = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

vim.g.neovide_refresh_rate = 59
vim.g.neovide_fullscreen = false

-- if vim.g.neovide then
--   opt.columns = 200
--   opt.lines = 86
-- end

opt.smoothscroll = false

opt.wrap = true
opt.linebreak = true
opt.breakindent = true
opt.sidescroll = 1 -- minimal horizontal shift per scroll
opt.sidescrolloff = 2 -- keep small margin before scrolling
