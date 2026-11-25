-- Per-project switch for the rewrites Neovim does on save: conform's
-- format_on_save (lua/plugins/init.lua), the trailing-whitespace trim and
-- fixendofline (lua/core/autocmds.lua).
--
-- An empty `.no-autoformat` file in a folder (or any folder above the file)
-- turns them off for everything below it. For legacy code whose formatting,
-- line endings and encoding must survive an edit untouched. The playbook
-- creates the markers listed in nvim_no_autoformat_dirs (personal-config.yml).
--
-- :AutoFormatToggle turns format-on-save and the trim off/on for one buffer.
-- Formatting by hand (<leader>fm) always works.
local M = {}

-- True when the folder holding this buffer's file, or one above it, has a
-- `.no-autoformat` marker. Ignores the per-buffer toggle.
function M.marked(bufnr)
  local path = vim.api.nvim_buf_get_name(bufnr)
  if path == "" then
    return false
  end

  local marker = vim.fs.find(".no-autoformat", {
    path = vim.fs.dirname(path),
    upward = true,
  })
  return marker[1] ~= nil
end

-- True when save-time rewrites should be skipped for this buffer.
function M.disabled(bufnr)
  if bufnr == 0 then
    bufnr = vim.api.nvim_get_current_buf()
  end
  if vim.b[bufnr].disable_autoformat then
    return true
  end
  return M.marked(bufnr)
end

vim.api.nvim_create_user_command("AutoFormatToggle", function()
  vim.b.disable_autoformat = not vim.b.disable_autoformat
  print("Format on save: " .. (vim.b.disable_autoformat and "off" or "on") .. " for this buffer")
end, {})

return M
