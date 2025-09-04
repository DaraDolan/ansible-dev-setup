# DevEnv Ansible Setup

An Ansible playbook for automating the setup of a consistent development environment across multiple machines with customized Zsh, shell tools, and common development software.

## Overview

This project uses Ansible to automate the installation and configuration of:

- Common development software (git, curl, wget, Python, Node.js, etc.)
- Zsh as the default shell with Oh-My-Zsh
- Zinit plugin manager for Zsh plugins
- Powerlevel10k theme with a pre-configured setup
- Zoxide for fast directory navigation
- Various Zsh plugins for enhanced productivity

The setup is designed to work on both Debian-based Linux distributions (Ubuntu, Debian) and macOS.

## Prerequisites

- Ansible 2.9+ installed on your control machine
- SSH access to target machines (or localhost for local setup)
- Sudo privileges on target machines

## Personal Configuration (Important First Step!)

Before running the setup, it's **highly recommended** to configure your personal settings:

```bash
# Copy the example configuration
cp personal-config.yml.example personal-config.yml

# Edit with your personal preferences
nano personal-config.yml  # or vim, code, etc.
```

The personal configuration file allows you to set:

- **Git user name and email** (instead of using system defaults)
- **Git default branch** (main, master, develop, etc.)
- **Git pull behavior** (merge vs rebase)
- **Whether to configure Git at all** (useful for shared systems)

**Example `personal-config.yml`:**
```yaml
---
# Git Configuration
git_user_name: "Jane Developer"
git_user_email: "jane@company.com"
git_default_branch: "main"
git_pull_rebase: false

# To skip git configuration entirely:
# configure_git: false
```

**Why this matters:** Without personal configuration, the playbook will use system defaults like your username and `username@example.com` for Git commits.

## Installation

### Option 1: Quick Setup Script (Recommended)

For convenience with enhanced error handling and auto-installation of Ansible:

```bash
git clone <your-repo-url>
cd <repo-directory>

# Configure your personal settings first (recommended)
cp personal-config.yml.example personal-config.yml
nano personal-config.yml

# Run setup
./scripts/dev-setup.sh
```

This script is a convenience wrapper that:
- Automatically installs Ansible if missing
- Provides enhanced error handling with colored output
- Runs the complete Ansible playbook
- Shows helpful next steps after completion

**Note**: The script will prompt for your sudo password when needed.

### Option 2: Direct Ansible Playbook

For a minimal installation without Laravel-specific aliases and functions:

1. Clone this repository:

```bash
git clone <your-repo-url>
cd <repo-directory>
```

2. Configure your personal settings (recommended):

```bash
cp personal-config.yml.example personal-config.yml
nano personal-config.yml
```

3. Run the playbook:

```bash
# With personal configuration
ansible-playbook -i inventory/hosts.yml playbook.yml -e @personal-config.yml -K

# Or with defaults (not recommended)
ansible-playbook -i inventory/hosts.yml playbook.yml -K
```

**What you get:**
- Complete development environment (Neovim, Zsh, packages)
- Laravel-specific aliases and functions
- Tool configurations and dotfiles
- Project directory structure
- Cross-platform compatibility

**Note:** Both options now provide the same functionality - the script is just a convenience wrapper with better error handling.

3. Optional: Review and modify the inventory file `inventory/hosts.yml` if needed:

```yaml
all:
  hosts:
    localhost:
      ansible_connection: local
    # Add additional hosts as needed
    # remote-host:
    #   ansible_host: 192.168.1.100
    #   ansible_user: yourusername
```

**Running on specific hosts:**

```bash
# Specific host
ansible-playbook -i inventory/hosts.yml playbook.yml -l hostname -K

# Remote host with SSH
ansible-playbook -i inventory/hosts.yml playbook.yml -l remote-host -K

# Setup specific components only (using tags)
ansible-playbook -i inventory/hosts.yml playbook.yml --tags neovim -K
ansible-playbook -i inventory/hosts.yml playbook.yml --tags laravel -K
ansible-playbook -i inventory/hosts.yml playbook.yml --tags zsh -K
```

### Configuration Updates

For updating just configuration files (after making changes to roles):

```bash
# Update Neovim configuration only (fast, no package reinstalls)
ansible-playbook update-config.yml

# This updates:
# - Plugin configurations  
# - Key mappings
# - Core settings
# - Code snippets
```

This is much faster than running the full playbook when you only need to update config files.

## Project Structure

```
ansible-dev-setup/
├── playbook.yml              # Main setup playbook
├── update-config.yml         # Quick config update playbook  
├── inventory/hosts.yml       # Ansible inventory
├── roles/
│   ├── common-software/      # Base development tools
│   ├── neovim/              # Neovim configuration
│   │   ├── files/           # Source configuration files
│   │   │   ├── init.lua
│   │   │   ├── lua/core/    # Core Neovim settings
│   │   │   ├── lua/plugins/ # Plugin configurations
│   │   │   └── snippets/    # Code snippets
│   │   └── tasks/main.yml   # Installation tasks
│   ├── laravel/             # Laravel-specific setup
│   └── zsh/                 # Shell configuration
├── scripts/dev-setup.sh     # Convenience setup script
└── CLAUDE.md               # Claude Code integration docs
```

## Features

### Common Software Installation

The playbook installs common development tools based on your operating system:

- **Linux (Debian/Ubuntu)**: git, curl, wget, build-essential, zsh, python3, python3-pip, python3-venv, nodejs, npm
- **macOS**: git, curl, wget, zsh, python, node

### Zsh Configuration

- Sets Zsh as the default shell
- Installs Oh-My-Zsh for base configuration
- Sets up Zinit plugin manager with useful plugins:
  - fast-syntax-highlighting
  - zsh-autosuggestions
  - zsh-completions
  - zsh-history-substring-search
  - zsh-artisan (Laravel helper)
  - tipz
  - powerlevel10k (theme)

### Powerlevel10k Theme

A sophisticated shell prompt with:
- Git status information
- Directory navigation
- Command execution time
- Error status
- Various version managers (Python, Node.js, etc.)
- Environment indicators (virtualenv, AWS, kubernetes, etc.)

### Additional Tools

- **Zoxide**: A smarter alternative to the `cd` command for faster directory navigation

## Configuration Options

### Personal Configuration Variables

The following variables can be customized in `personal-config.yml`:

| Variable | Default | Description |
|----------|---------|-------------|
| `git_user_name` | `{{ ansible_user_id \| title }}` | Git user name for commits |
| `git_user_email` | `{{ ansible_user_id }}@example.com` | Git user email for commits |
| `git_default_branch` | `main` | Default branch name for new repositories |
| `git_pull_rebase` | `false` | Whether to rebase or merge on git pull |
| `git_config_scope` | `global` | Git config scope (global or local) |
| `configure_git` | `true` | Whether to configure Git at all |

### Advanced Usage

```bash
# Override individual settings at runtime
ansible-playbook playbook.yml -e git_user_name="Different Name" -K

# Use different config files for different environments  
ansible-playbook playbook.yml -e @work-config.yml -K
ansible-playbook playbook.yml -e @home-config.yml -K

# Skip git configuration entirely
ansible-playbook playbook.yml -e configure_git=false -K

# Set git config to local instead of global
ansible-playbook playbook.yml -e git_config_scope=local -K
```

### Multiple Configuration Files

You can create different configuration files for different contexts:

```bash
# Work setup
cp personal-config.yml.example work-config.yml
# Home setup  
cp personal-config.yml.example home-config.yml
# Shared/server setup
cp personal-config.yml.example server-config.yml
```

## Customization

### Adding Custom Software

To add more software packages:

1. Edit the appropriate vars file in `roles/common-software/vars/`:
   - `Darwin.yml` for macOS
   - `Debian.yml` for Debian/Ubuntu

2. Add your package to the `software_packages` list.

### Adding Zsh Plugins

To add more Zsh plugins:

1. Edit `roles/zsh/files/zinit.zsh` and add your desired plugins using the Zinit syntax.
2. Edit `roles/zsh/files/zshrc` to modify Oh-My-Zsh plugins in the `plugins=()` array.

### Customizing Powerlevel10k

If you want to customize the Powerlevel10k theme:

1. After installation, run `p10k configure` in your terminal to create a new configuration.
2. Or edit `roles/zsh/files/p10k.zsh` directly to modify the existing configuration.

## Structure

```
.
├── ansible.cfg              # Ansible configuration
├── inventory
│   └── hosts.yml           # Inventory file with hosts definitions
├── playbook.yml            # Main playbook
└── roles
    ├── common-software     # Role for installing software packages
    │   ├── tasks
    │   │   └── main.yml    # Tasks for software installation
    │   └── vars
    │       ├── Darwin.yml  # macOS specific packages
    │       └── Debian.yml  # Debian/Ubuntu specific packages
    └── zsh                 # Role for Zsh configuration
        ├── files
        │   ├── p10k.zsh    # Powerlevel10k configuration
        │   ├── zinit.zsh   # Zinit plugins configuration
        │   └── zshrc       # Main Zsh configuration
        └── tasks
            └── main.yml    # Tasks for Zsh setup
```

## Troubleshooting

### Common Issues

#### Quick Setup Script Issues
- **"sudo: a terminal is required"**: Run the script with `sudo ./scripts/dev-setup.sh` instead of `./scripts/dev-setup.sh`
- **Script fails on package installation**: Ensure you have sudo privileges and internet connection
- **Ansible not found**: Script will automatically install Ansible if missing

#### General Issues
- **Shell not changing to Zsh**: Log out and log back in after the playbook completes
- **Plugins not loading**: Run `source ~/.zshrc` or restart your terminal
- **Font issues with Powerlevel10k**: Install a [Nerd Font](https://www.nerdfonts.com/) and configure your terminal to use it

#### Alternative Approaches
If the quick setup script fails:
1. Try the Ansible-only approach: `ansible-playbook -i inventory/hosts.yml playbook.yml -K`
2. Install packages manually and re-run the script
3. Configure passwordless sudo temporarily (see script error message for instructions)

### Debugging

If you encounter issues, run the playbook with increased verbosity:

```bash
ansible-playbook -i inventory/hosts.yml playbook.yml -K -v
```

For more detailed output:

```bash
ansible-playbook -i inventory/hosts.yml playbook.yml -K -vvv
```

## License

[Your License Here]

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

