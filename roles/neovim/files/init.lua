-- Neovim main configuration file

-- Set leader key to space (do this before loading plugins)
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Bootstrap the plugin manager (lazy.nvim)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load core configuration
require("core")

-- Setup and load plugins with lazy.nvim
require("lazy").setup("plugins")
