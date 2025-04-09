-- Autocommands
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- General settings
local general = augroup("General", { clear = true })

-- Highlight on yank
autocmd("TextYankPost", {
  group = general,
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})

-- Remember last position in file
autocmd("BufReadPost", {
  group = general,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Terminal defaults (from your sanity.vim)
if vim.fn.has('nvim') == 1 then
  autocmd("TermOpen", {
    group = augroup("neovim_terminal", { clear = true }),
    pattern = "*",
    callback = function()
      vim.api.nvim_buf_set_keymap(0, "n", "<C-c>", "i<C-c>", { noremap = true })
    end,
  })
end

-- Auto-delete test terminal buffers (from your vim-test.vim)
local test_buffers = augroup("AutoDeleteTestTermBuffers", { clear = true })
autocmd("BufLeave", {
  group = test_buffers,
  pattern = "term://*artisan\\stest*",
  command = "bdelete!",
})
autocmd("BufLeave", {
  group = test_buffers,
  pattern = "term://*phpunit*",
  command = "bdelete!",
})

-- Set terminal title dynamically
local function update_window_title()
  local current_project = vim.fn.substitute(vim.fn.getcwd(), '^.*/', '', '')
  vim.opt.titlestring = "nvim (" .. current_project .. ")"
end

autocmd({ "DirChanged", "VimEnter" }, {
  group = general,
  callback = update_window_title,
})

-- Check if file changed when gaining focus or when entering a buffer
autocmd({ "FocusGained", "BufEnter" }, {
  group = general,
  command = "checktime",
})

-- Filetype specific settings
local ft = augroup("FileTypeSettings", { clear = true })

-- Markdown settings (from your markdown.vim)
autocmd("FileType", {
  group = ft,
  pattern = "markdown",
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_gb"
    vim.opt_local.wrap = true
  end,
})

-- PHP settings
autocmd("FileType", {
  group = ft,
  pattern = "php",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
  end,
})

-- Web development settings
autocmd("FileType", {
  group = ft,
  pattern = { "html", "css", "javascript", "typescript", "vue", "svelte" },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end,
})

-- Automatically remove trailing whitespace
autocmd("BufWritePre", {
  group = general,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})
