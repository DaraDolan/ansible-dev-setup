return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<M-l>",
            next = "<M-j>",
            prev = "<M-k>",
            dismiss = "<M-h>",
          },
        },
        panel = { enabled = false },
        filetypes = {
          ["*"] = false,
          php = true,
          blade = true,
          javascript = true,
          javascriptreact = true,
          typescript = true,
          typescriptreact = true,
          vue = true,
          html = true,
          css = true,
          lua = true,
          python = true,
          markdown = true,
          json = true,
          TelescopePrompt = false,
          fugitive = false,
          gitcommit = false,
          help = false,
        },
      })

      -- Tracked separately so lualine (see plugins/init.lua) can show enabled/disabled status
      vim.g.copilot_enabled = 1
      vim.api.nvim_create_user_command("CopilotToggle", function()
        if vim.g.copilot_enabled == 0 then
          vim.cmd("Copilot enable")
          vim.g.copilot_enabled = 1
          vim.notify("Copilot enabled", vim.log.levels.INFO)
        else
          vim.cmd("Copilot disable")
          vim.g.copilot_enabled = 0
          vim.notify("Copilot disabled", vim.log.levels.WARN)
        end
      end, { desc = "Toggle GitHub Copilot" })
    end,
  },
}
