# Quick Setup Commands

## Ansible Setup (Requires sudo password)

### Full Environment Setup
```bash
ansible-playbook playbook.yml -K
```
*This will prompt you for your sudo password and install everything*

### Install Specific Components
```bash
# Python development (UV + LSP)
ansible-playbook playbook.yml --tags python -K

# Neovim editor with all plugins
ansible-playbook playbook.yml --tags neovim -K

# Laravel/PHP development
ansible-playbook playbook.yml --tags laravel -K

# Zsh shell configuration
ansible-playbook playbook.yml --tags zsh -K
```

### Update Configuration Only (Fast)
```bash
# Update config files without reinstalling packages
ansible-playbook update-config.yml -K
```

## Alternative: Use the Setup Script
If you prefer the convenience wrapper:
```bash
./scripts/dev-setup.sh
```

## What the `-K` flag does:
- `-K` is shorthand for `--ask-become-pass`
- Prompts you to enter your sudo password
- Required because the playbook needs to install system packages
- Your password is only used for sudo operations, not stored

## Why sudo is needed:
- Installing system packages (Python, Node.js, PHP, etc.)
- Setting up Neovim with system dependencies
- Configuring shell (zsh) as default
- Installing development tools and libraries

Once setup is complete, your regular development workflow won't need sudo privileges.