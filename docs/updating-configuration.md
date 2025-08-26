# Updating Your Development Configuration

This guide explains how to update various parts of your development setup using Ansible.

## Quick Reference

```bash
# Run full setup (requires sudo password)
ansible-playbook -i inventory/hosts.yml playbook.yml --ask-become-pass

# Run specific role only
ansible-playbook -i inventory/hosts.yml playbook.yml --tags neovim --ask-become-pass
ansible-playbook -i inventory/hosts.yml playbook.yml --tags zsh --ask-become-pass

# Test configuration without making changes
ansible-playbook -i inventory/hosts.yml playbook.yml --check --ask-become-pass
```

## Updating Neovim Configuration

### Adding New Plugins

1. **Edit the plugin configuration:**
   ```bash
   # Edit the main plugin file
   vim roles/neovim/files/lua/plugins/init.lua
   ```

2. **Add your plugin to the return table:**
   ```lua
   -- Example: Adding a new plugin
   {
     "author/plugin-name",
     config = function()
       require("plugin-name").setup()
     end,
   },
   ```

3. **Apply the changes:**
   ```bash
   # Run ansible to update configuration
   ansible-playbook -i inventory/hosts.yml playbook.yml --tags neovim --ask-become-pass
   
   # OR copy manually for quick testing
   cp roles/neovim/files/lua/plugins/init.lua ~/.config/nvim/lua/plugins/init.lua
   ```

4. **Restart Neovim and install plugins:**
   - Open Neovim: `nvim`
   - Run: `:Lazy sync`
   - Restart Neovim

### Adding New Keybindings

1. **Edit keymaps file:**
   ```bash
   vim roles/neovim/files/lua/core/keymaps.lua
   ```

2. **Add your keybinding:**
   ```lua
   -- Example: Add new keybinding
   vim.keymap.set("n", "<leader>nt", ":Neotree toggle<CR>", { desc = "Toggle Neotree" })
   ```

3. **Apply changes:**
   ```bash
   ansible-playbook -i inventory/hosts.yml playbook.yml --tags neovim --ask-become-pass
   ```

### Adding LSP Servers

1. **Edit the plugin configuration:**
   ```bash
   vim roles/neovim/files/lua/plugins/init.lua
   ```

2. **Add LSP server to mason-lspconfig ensure_installed:**
   ```lua
   require("mason-lspconfig").setup({
     ensure_installed = {
       "intelephense", -- PHP
       "html",         -- HTML
       "your_new_lsp", -- Add here
     },
   })
   ```

3. **Add LSP configuration:**
   ```lua
   -- Add after existing LSP configs
   lspconfig.your_new_lsp.setup({
     capabilities = capabilities,
     -- Add specific settings here
   })
   ```

### Adding Snippets

1. **Create or edit snippet file:**
   ```bash
   # For PHP snippets
   vim roles/neovim/files/snippets/php.json
   
   # For JavaScript snippets  
   vim roles/neovim/files/snippets/javascript.json
   ```

2. **Add new snippet:**
   ```json
   {
     "snippet_name": {
       "prefix": "trigger",
       "body": [
         "line 1",
         "line 2 with ${1:placeholder}"
       ],
       "description": "Description of snippet"
     }
   }
   ```

3. **Apply changes:**
   ```bash
   ansible-playbook -i inventory/hosts.yml playbook.yml --tags neovim --ask-become-pass
   ```

## Updating Zsh Configuration

### Adding New Aliases

1. **Edit zshrc file:**
   ```bash
   vim roles/zsh/files/zshrc
   ```

2. **Add aliases in the appropriate section:**
   ```bash
   # Laravel aliases section
   alias pa='php artisan'
   alias pam='php artisan migrate'
   alias your_new_alias='your_command'
   ```

3. **Apply changes:**
   ```bash
   ansible-playbook -i inventory/hosts.yml playbook.yml --tags zsh --ask-become-pass
   
   # OR copy manually
   cp roles/zsh/files/zshrc ~/.zshrc && source ~/.zshrc
   ```

### Adding Zsh Plugins

1. **Edit zinit configuration:**
   ```bash
   vim roles/zsh/files/zinit.zsh
   ```

2. **Add plugin loading:**
   ```bash
   # Add new plugin
   zinit load "author/plugin-name"
   
   # Or with specific options
   zinit ice wait"1" lucid
   zinit load "author/plugin-name"
   ```

3. **Apply changes:**
   ```bash
   ansible-playbook -i inventory/hosts.yml playbook.yml --tags zsh --ask-become-pass
   ```

### Customizing Powerlevel10k

1. **Edit p10k configuration:**
   ```bash
   vim roles/zsh/files/p10k.zsh
   ```

2. **Apply changes:**
   ```bash
   ansible-playbook -i inventory/hosts.yml playbook.yml --tags zsh --ask-become-pass
   ```

## Running Ansible Playbooks

### Full Setup
```bash
# Complete development environment setup
ansible-playbook -i inventory/hosts.yml playbook.yml --ask-become-pass
```

### Specific Roles Only
```bash
# Only update Neovim
ansible-playbook -i inventory/hosts.yml playbook.yml --tags neovim --ask-become-pass

# Only update Zsh
ansible-playbook -i inventory/hosts.yml playbook.yml --tags zsh --ask-become-pass

# Only update common software
ansible-playbook -i inventory/hosts.yml playbook.yml --tags common --ask-become-pass

# Only update Laravel tools
ansible-playbook -i inventory/hosts.yml playbook.yml --tags laravel --ask-become-pass
```

### Dry Run (Test Changes)
```bash
# See what would change without applying
ansible-playbook -i inventory/hosts.yml playbook.yml --check --ask-become-pass

# Verbose output for debugging
ansible-playbook -i inventory/hosts.yml playbook.yml -v --ask-become-pass
```

### Common Issues and Solutions

#### Password Issues
```bash
# If sudo password doesn't work
ansible-playbook -i inventory/hosts.yml playbook.yml --become-method=sudo --ask-become-pass

# Skip tasks requiring sudo (limited functionality)
ansible-playbook -i inventory/hosts.yml playbook.yml --skip-tags="sudo"
```

#### Manual File Copy (Quick Testing)
```bash
# Manually copy specific files for quick testing
cp roles/neovim/files/lua/plugins/init.lua ~/.config/nvim/lua/plugins/init.lua
cp roles/neovim/files/lua/core/keymaps.lua ~/.config/nvim/lua/core/keymaps.lua
cp roles/zsh/files/zshrc ~/.zshrc && source ~/.zshrc
```

#### Verify Changes
```bash
# Check Neovim health after updates
nvim --headless -c "checkhealth" -c "q"

# Test Zsh configuration
zsh -n ~/.zshrc  # Check syntax
echo $ZSH_VERSION  # Verify Zsh is running
```

## Disabling Claude Code Telemetry

If you want to completely disable Claude Code telemetry (which is included in the ansible setup), you can verify it's disabled by checking:

```bash
# Check if telemetry is disabled in settings
cat ~/.claude/settings.json

# Check environment variables (should not show CLAUDE_CODE_ENABLE_TELEMETRY=1)
env | grep CLAUDE

# Apply ansible changes to ensure telemetry stays disabled
ansible-playbook -i inventory/hosts.yml playbook.yml --ask-become-pass
```

The ansible setup automatically:
- Sets `CLAUDE_CODE_ENABLE_TELEMETRY=0` in your shell
- Creates `~/.claude/settings.json` with `"enableTelemetry": false`
- Unsets any existing telemetry environment variables

## Development Workflow

### Making Changes
1. **Edit configuration files** in `roles/*/files/`
2. **Test locally** by copying files manually (optional)
3. **Run ansible** to apply changes system-wide
4. **Verify** the changes work correctly
5. **Commit** your changes to version control

### Example: Adding a New Vim Plugin
```bash
# 1. Edit plugin config
vim roles/neovim/files/lua/plugins/init.lua

# 2. Test the change
cp roles/neovim/files/lua/plugins/init.lua ~/.config/nvim/lua/plugins/init.lua
nvim  # Test in Neovim with :Lazy sync

# 3. Apply via Ansible (if test successful)
ansible-playbook -i inventory/hosts.yml playbook.yml --tags neovim --ask-become-pass

# 4. Commit the change
git add roles/neovim/files/lua/plugins/init.lua
git commit -m "Add new vim plugin: plugin-name"
```

### Creating Backup
```bash
# Backup current configs before major changes
tar -czf ~/config-backup-$(date +%Y%m%d).tar.gz ~/.config/nvim ~/.zshrc ~/.p10k.zsh
```

This documentation should cover most scenarios for updating your development environment. Remember to always test changes in a safe environment before applying them system-wide.