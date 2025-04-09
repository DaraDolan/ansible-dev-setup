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

## Installation

1. Clone this repository:

```bash
git clone <your-repo-url>
cd <repo-directory>
```

2. Review and modify the inventory file `inventory/hosts.yml` if needed:

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

3. Run the playbook:

```bash
ansible-playbook playbook.yml
```

To run on a specific host:

```bash
ansible-playbook playbook.yml -l hostname
```

For localhost only:

```bash
ansible-playbook playbook.yml -l localhost
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

- **Shell not changing to Zsh**: Log out and log back in after the playbook completes
- **Plugins not loading**: Run `source ~/.zshrc` or restart your terminal
- **Font issues with Powerlevel10k**: Install a [Nerd Font](https://www.nerdfonts.com/) and configure your terminal to use it

### Debugging

If you encounter issues, run the playbook with increased verbosity:

```bash
ansible-playbook playbook.yml -v
```

For more detailed output:

```bash
ansible-playbook playbook.yml -vvv
```

## License

[Your License Here]

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

