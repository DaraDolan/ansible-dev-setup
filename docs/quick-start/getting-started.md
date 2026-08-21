# 🚀 Quick Start Guide

Get up and running with your development environment in minutes!

## ⚡ Setup Options

### Option 1: Full Setup with Laravel Tools (Recommended)

```bash
# 1. Run the setup script (includes Laravel aliases & functions)
cd /home/dara/development/ansible-dev-setup
./scripts/dev-setup.sh

# 2. Reload your shell
source ~/.zshrc

# 3. Create your first project
laravel-new my-awesome-project react

# 4. Start developing
cd ~/development/projects/my-awesome-project
dev-start  # Starts Laravel + Vite servers
```

### Option 2: Direct Playbook

```bash
# 1. Run the Ansible playbook directly
cd /home/dara/development/ansible-dev-setup
ansible-playbook -i inventory/hosts.yml playbook.yml -K

# 2. Reload your shell
source ~/.zshrc

# 3. Create your first project
laravel-new my-awesome-project react

# 4. Start developing
cd ~/development/projects/my-awesome-project
dev-start  # Starts Laravel + Vite servers
```

**Note:** Same functionality as the script, just without the convenience wrapper and enhanced error messages.

## 🎯 First Project Checklist

- [x] **Environment Setup** - Run `./test-setup.sh` to verify
- [x] **Laravel Project** - Create with `laravel-new project-name react`
- [x] **Development Servers** - Start with `dev-start`
- [x] **Editor Ready** - Open with `nv .` or `cc`
- [x] **Tests Passing** - Run `pest`

## 🔧 Essential Commands

| Command | Purpose |
|---------|---------|
| `laravel-new project [react]` | Create new Laravel project |
| `dev-start` | Start all development servers |
| `nv .` | Open in Neovim |
| `cc` | Open in Claude Code |
| `pest` | Run tests |
| `art serve` | Laravel development server |
| `npm run dev` | Frontend build server |

## 🎨 What's Included

- ✅ **PHP 8.3** with all extensions
- ✅ **Laravel 12** with Pest 4 testing
- ✅ **React + TypeScript** setup
- ✅ **Tailwind CSS** configured
- ✅ **Neovim** with 30+ plugins
- ✅ **Claude Code** integration
- ✅ **Zsh + Zinit + Starship** prompt and plugins

## ⚡ Next Steps

1. [📚 Learn the Daily Workflow](../daily-workflow/README.md)
2. [⌨️  Master Neovim Shortcuts](../neovim/keybindings.md)
3. [🧪 Explore Pest Testing](../testing/pest-guide.md)
4. [⚛️  Build with React](../frontend/react-setup.md)

## 🆘 Need Help?

- **Test Environment**: `./test-setup.sh`
- **Documentation Index**: [📖 Main Index](../README.md)
- **Troubleshooting**: [🔧 Common Issues](../quick-start/troubleshooting.md)

**Happy coding!** 🎉