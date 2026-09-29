-- Treesitter parsers to install. Shared by the nvim-treesitter plugin config
-- (lua/plugins/init.lua) and the Ansible handler that compiles them headless
-- (roles/neovim/handlers/main.yml), so the two can't drift apart.
return {
  "lua", "vim", "vimdoc", "query", -- Neovim
  "php", "html", "css", "javascript", "typescript", "tsx", -- Web
  "json", "yaml", "markdown", "markdown_inline", -- Data & Docs
  "bash", "python", -- Scripts
  "blade", "vue", -- Laravel specific
}
