-- Neovim options
local opt = vim.opt

-- Core settings (from your sanity.vim)
opt.backup = false
opt.number = true
opt.relativenumber = true
opt.swapfile = false
opt.autoread = true
opt.confirm = true
opt.encoding = "utf-8"
opt.clipboard = "unnamedplus"
opt.backspace = "indent,eol,start"
opt.showmode = false
opt.splitbelow = true
opt.splitright = true
opt.title = true
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.scrolloff = 5
opt.completeopt = "menu,menuone,noinsert,noselect"
opt.wrap = false
opt.autoindent = true
opt.smartindent = true
opt.termguicolors = true -- Enable 24-bit RGB colors

-- File type detection and plugin loading
vim.cmd("filetype plugin on")

-- Create undo directory if it doesn't exist
local undodir = vim.fn.stdpath("data") .. "/undo"
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end
opt.undodir = undodir
opt.undofile = true  -- Enable persistent undo

-- Set tab/space preferences (can be overridden in ftplugin files)
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4

-- Search down into subfolders (provides tab completion for all file-related tasks)
opt.path:append("**")

-- Display all matching files when tab complete
opt.wildmenu = true

-- Set cursor to block in normal mode, beam in insert mode
opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"

-- Performance
opt.lazyredraw = true
opt.updatetime = 250
opt.timeoutlen = 300
