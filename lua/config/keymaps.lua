-- ============================================================================
-- CLEANUP - Remove LazyVim defaults
-- ============================================================================

local deletions = {
  { "n", "<leader><tab>l" },
  { "n", "<leader><tab>o" },
  { "n", "<leader><tab>f" },
  { "n", "<leader><tab><tab>" },
  { "n", "<leader><tab>]" },
  { "n", "<leader><tab>d" },
  { "n", "<leader><tab>[" },
  { "n", "<leader><space>" },
}

for _, map in ipairs(deletions) do
  vim.keymap.del(map[1], map[2])
end

-- ============================================================================
-- NAVIGATION
-- ============================================================================

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half-page down + center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half-page up + center" })
vim.keymap.set("n", "gj", "10jzz", { desc = "Jump down 10 lines + center" })
vim.keymap.set("n", "gk", "10kzz", { desc = "Jump up 10 lines + center" })

vim.keymap.set("n", "m", "<Nop>", { desc = "Disable for mini.surround", silent = true, noremap = true })
vim.keymap.set({ "n", "v", "x" }, "mm", "%", { desc = "Match bracket", noremap = true, silent = true })

vim.keymap.set("n", "mc", "m", { desc = "Set mark", noremap = true, silent = true })
vim.keymap.set("n", "m'", "'", { desc = "Jump to mark", noremap = true, silent = true })
vim.keymap.set("n", "m`", "`", { desc = "Jump to mark (exact)", noremap = true, silent = true })

-- ============================================================================
-- BUFFER MANAGEMENT
-- ============================================================================

vim.keymap.set("n", "<S-Tab>", "<Cmd>b#<CR>", { desc = "Alternate buffer" })
vim.keymap.set("n", "<leader><Tab>", function()
  Snacks.picker.buffers()
end, { desc = "Buffer picker" })

vim.keymap.set("n", "<A-S-q>", function()
  Snacks.bufdelete({ win = true })
end, { desc = "Delete buffer + window" })

-- ============================================================================
-- WINDOW MANAGEMENT
-- ============================================================================

vim.keymap.set("n", "<Tab>", function()
  local start_win = vim.api.nvim_get_current_win()
  local cur_win = start_win
  repeat
    vim.cmd("wincmd w")
    cur_win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_win_get_buf(cur_win)
    local buf_type = vim.api.nvim_get_option_value("buftype", { buf = buf })
    local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })
    if buf_type == "" and filetype ~= "help" and filetype ~= "quickfix" then
      return
    end
  until cur_win == start_win
end, { desc = "Next code window" })

-- ============================================================================
-- DIAGNOSTICS
-- ============================================================================

local function yank_line_diagnostics()
  local bufnr = vim.api.nvim_get_current_buf()
  local line = vim.api.nvim_win_get_cursor(0)[1] - 1
  local diags = vim.diagnostic.get(bufnr, { lnum = line })
  if #diags == 0 then
    vim.notify("No diagnostics on this line", vim.log.levels.INFO)
    return
  end
  local msgs = vim.tbl_map(function(d)
    return d.message
  end, diags)
  vim.fn.setreg("+", table.concat(msgs, "\n"))
end

local function yank_all_diagnostics()
  local diags = vim.diagnostic.get()
  local lines = {}
  for _, d in ipairs(diags) do
    local fname = vim.api.nvim_buf_get_name(d.bufnr)
    local rel = vim.fn.fnamemodify(fname, ":.")
    table.insert(lines, string.format("@%s %d:%d: %s", rel, d.lnum + 1, d.col + 1, d.message))
  end
  vim.fn.setreg("+", table.concat(lines, "\n"))
end

vim.keymap.set("n", "<leader><leader>x", yank_line_diagnostics, { desc = "Yank line diagnostics" })
vim.keymap.set("n", "<leader><leader>d", yank_all_diagnostics, { desc = "Yank all diagnostics" })

-- ============================================================================
-- TEXT OPERATIONS
-- ============================================================================

vim.keymap.set("n", "<leader>v", "viw", { desc = "Select inner word" })
vim.keymap.set("n", "q", "<Nop>", { desc = "Disable macro recording" })
vim.keymap.set("n", "Q", "<Nop>", { desc = "Disable ex mode" })

-- ============================================================================
-- EXTERNAL TOOLS
-- ============================================================================

vim.keymap.set("n", "<space><space>f", function()
  local path = vim.fn.expand("%:p:h")
  if path ~= "" then
    vim.fn.jobstart({ "footclient", "-a", "foot.yazi", "-e", "/home/wasd/architect/scripts/ynv", path }, {
      detach = true,
      env = {
        NVIM_LISTEN_ADDRESS = vim.v.servername,
      },
    })
  end
end, { desc = "Open yazi in foot" })

vim.keymap.set("n", "<leader>sz", function()
  vim.fn.jobstart({ "chezmoi", "apply" }, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data and data[1] ~= "" then
        vim.notify(table.concat(data, "\n"), vim.log.levels.INFO)
      end
    end,
    on_stderr = function(_, data)
      if data and data[1] ~= "" then
        vim.notify(table.concat(data, "\n"), vim.log.levels.ERROR)
      end
    end,
    on_exit = function(_, code)
      local level = code == 0 and vim.log.levels.INFO or vim.log.levels.ERROR
      vim.notify("chezmoi apply exited with code " .. code, level)
    end,
  })
end, { desc = "Apply chezmoi" })

-- ============================================================================
-- QUICK ACCESS
-- ============================================================================

vim.keymap.set("n", "<leader>on", ":edit ~/notes/quick.md<CR>", { desc = "Open quick notes" })

-- ============================================================================
-- NEOVIDE-SPECIFIC
-- ============================================================================

if vim.g.neovide then
  -- Window navigation
  vim.keymap.set("n", "<A-h>", "<C-w>h", { desc = "Focus left" })
  vim.keymap.set("n", "<A-j>", "<C-w>j", { desc = "Focus down" })
  vim.keymap.set("n", "<A-k>", "<C-w>k", { desc = "Focus up" })
  vim.keymap.set("n", "<A-l>", "<C-w>l", { desc = "Focus right" })
  vim.keymap.set("n", "<A-Tab>", ":bnext<CR>", { desc = "Next buffer" })

  -- Window management
  vim.keymap.set("n", "<A-Enter>", "<C-w>v", { desc = "Split vertical" })
  vim.keymap.set("n", "<A-f>", "<C-w>_|<C-w>|", { desc = "Maximize window" })
  vim.keymap.set("n", "<A-q>", function()
    if #vim.api.nvim_tabpage_list_wins(0) > 1 then
      vim.cmd("close")
    end
  end, { desc = "Close window" })

  vim.keymap.set("n", "<A-S-q>", function()
    Snacks.bufdelete()
    vim.cmd("close")
  end, { desc = "Delete buffer and close window" })

  -- Window sizing
  vim.keymap.set("n", "<C-+>", "<C-w>+", { desc = "Increase height" })
  vim.keymap.set("n", "<C-->", "<C-w>-", { desc = "Decrease height" })
  vim.keymap.set("n", "<A-=>", "<C-w>>", { desc = "Increase width" })
  vim.keymap.set("n", "<A-[>", "<C-w><", { desc = "Decrease width" })

  -- Buffer navigation
  vim.keymap.set("n", "<C-Enter>", ":enew<CR>", { desc = "New buffer" })
  vim.keymap.set("n", "<C-Tab>", "<C-w>w", { desc = "Cycle windows" })
  vim.keymap.set("n", "<C-A-i>", ":bprevious<CR>", { desc = "Previous buffer" })
  vim.keymap.set("n", "<C-A-o>", ":bnext<CR>", { desc = "Next buffer" })
  vim.keymap.set("n", "<C-q>", function()
    Snacks.bufdelete()
  end, { desc = "Delete buffer" })
  vim.keymap.set("n", "<leader>qq", function()
    Snacks.bufdelete()
  end, { desc = "Delete buffer" })

  -- Clipboard operations
  vim.keymap.set({ "n", "v" }, "<C-S-c>", '"+y', { desc = "Copy to clipboard" })
  vim.keymap.set({ "n", "v" }, "<C-S-v>", '"+P', { desc = "Paste from clipboard" })
  vim.keymap.set("i", "<C-S-v>", '<ESC>"+pa', { desc = "Paste from clipboard" })
  vim.keymap.set("c", "<C-S-v>", "<C-R>+", { desc = "Paste from clipboard" })
  vim.keymap.set("t", "<C-S-v>", "<C-R>+", { desc = "Paste from clipboard" })
end

vim.g.neovide_scale_factor = 1.0
local change_scale_factor = function(delta)
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end
vim.keymap.set("n", "<C-=>", function()
  change_scale_factor(1.25)
end)
vim.keymap.set("n", "<C-->", function()
  change_scale_factor(1 / 1.25)
end)

vim.keymap.set("n", "<A-`>", "<C-o>", { noremap = true, silent = true })
