# 📚 Development Environment Documentation

Your complete guide to productive PHP/Laravel/React development with Pest testing and Claude Code integration.

## 🚀 Getting Started

### Quick Setup
- **[🚀 Quick Start Guide](quick-start/getting-started.md)** - Get up and running in minutes
- **[🔧 Troubleshooting](quick-start/troubleshooting.md)** - Fix common issues fast

### First Steps
1. Run `./scripts/dev-setup.sh` to set up your environment
2. Create your first project: `laravel-new my-project react`
3. Start developing: `dev-start`

---

## 📖 Core Guides

### 📅 Daily Development
- **[📅 Daily Workflow](daily-workflow/README.md)** - Your productive daily routine
  - Morning setup, development cycle, testing workflow
  - Git integration, deployment, and end-of-day cleanup

### ⌨️  Neovim Mastery  
- **[⌨️  Keybindings Reference](neovim/keybindings.md)** - Master every shortcut
  - File navigation, LSP functions, Laravel shortcuts
  - Git integration, testing, and Claude Code integration

### 🧪 Testing Excellence
- **[🧪 Pest Testing Guide](testing/pest-guide.md)** - Complete testing mastery
  - Feature & unit tests, advanced expectations, mocking
  - Laravel integration, coverage reports, best practices
- **[🚀 Pest 4 Upgrade](pest-upgrade.md)** - Latest Pest 4 features
  - Mutation testing, parallel execution, performance improvements

### ⚛️  Frontend Development
- **[⚛️  React + Laravel](frontend/react-setup.md)** - Modern frontend development  
  - Component patterns, API integration, Tailwind CSS
  - Form handling, testing, mobile responsive design

---

## ⚡ Quick Reference Cards

### 🎯 Essential Commands
| Task | Command |
|------|---------|
| **New Project** | `laravel-new project-name [react]` |
| **Start Servers** | `dev-start` |
| **Run Tests** | `pest` |
| **Open Neovim** | `nv .` |
| **Claude Code** | `cc` |

### ⌨️  Top Shortcuts
| Neovim | Action |
|--------|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Search content |
| `<leader>la` | Laravel artisan |
| `<leader>lt` | Run tests |
| `<leader>cc` | Claude Code |
| `gd` | Go to definition |

### 🧪 Testing Shortcuts
| Command | Purpose |
|---------|---------|
| `pest` | Run all tests |
| `pest --watch` | Auto-run on changes |
| `pest --coverage` | Coverage report |
| `pest --mutate` | Mutation testing |

---

## 📋 Cheat Sheets

### 🔤 Snippet Triggers

#### PHP/Laravel
- `controller` → Laravel controller
- `model` → Laravel model  
- `migration` → Database migration
- `route` → Laravel route

#### Pest Testing
- `pest` → Basic test
- `pestfeature` → Feature test
- `expect` → Expectation
- `dataset` → Test with datasets

#### React/TypeScript  
- `rfc` → React component
- `useState` → useState hook
- `useEffect` → useEffect hook

#### Tailwind CSS
- `btn` → Button component
- `card` → Card layout
- `grid` → Responsive grid

---

## 🛠️ Configuration & Setup

### Environment Files
- **[CLAUDE.md](../CLAUDE.md)** - Claude Code optimization settings
- **Neovim Config**: `~/.config/nvim/`
- **Zsh Config**: `~/.zshrc` 

### Directory Structure
```
~/development/
├── projects/           # Your Laravel projects
├── ansible-dev-setup/ # This environment setup
└── docs/              # This documentation
```

---

## 🎯 Workflow Patterns

### 🌅 Daily Development Routine
1. **Morning**: `dev-start` → `nv .` → `pest --watch`
2. **Development**: Code → Test → Refactor cycle
3. **Complex Tasks**: `<leader>cc` for Claude Code assistance
4. **Evening**: Git commit → Push changes

### 🧪 Test-Driven Development
1. Write failing test (`pestfeature` snippet)
2. Run test: `pest --filter="test name"`
3. Write minimal code to pass
4. Refactor and improve
5. Repeat cycle

### 🎨 Component Development  
1. Create component (`rfc` snippet in Neovim)
2. Add Tailwind styling (`card`, `btn` snippets)
3. Test in browser (auto-reload with Vite)
4. Write component tests

---

## 🆘 Help & Support

### Troubleshooting
- **[🔧 Common Issues](quick-start/troubleshooting.md)** - Quick fixes
- **Test Environment**: Run `./test-setup.sh`
- **Reset Everything**: Re-run `./scripts/dev-setup.sh`

### Learning Resources
- **Laravel Docs**: [laravel.com/docs](https://laravel.com/docs)
- **Pest Docs**: [pestphp.com](https://pestphp.com)
- **React Docs**: [react.dev](https://react.dev)
- **Tailwind Docs**: [tailwindcss.com](https://tailwindcss.com)

### Development Tools
- **Neovim Health**: `:checkhealth` in Neovim
- **Laravel Debug**: `APP_DEBUG=true` in `.env`
- **Test Coverage**: `pest --coverage --coverage-html=coverage`

---

## 📊 Environment Features

### ✅ What's Included
- **PHP 8.3** with all essential extensions
- **Laravel 12** with Pest 4 testing framework
- **Node.js 22** with React/TypeScript support  
- **Neovim** with 30+ productivity plugins
- **Tailwind CSS** for rapid UI development
- **Claude Code** seamless integration
- **Zsh + Oh-My-Zsh** with productivity plugins

### 🎯 Optimized For
- **Laravel Development**: Controllers, models, migrations, API development
- **React Frontend**: Components, hooks, TypeScript, responsive design
- **Test-Driven Development**: Pest testing, mutation testing, coverage
- **Rapid Prototyping**: Snippets, auto-completion, hot reload
- **Code Quality**: LSP integration, formatting, linting

---

## 🎉 Happy Coding!

Your development environment is configured for maximum productivity. Use this documentation as your daily reference for:

- ⚡ **Quick lookups** of shortcuts and commands
- 📚 **Deep dives** into specific technologies  
- 🔧 **Troubleshooting** when things go wrong
- 🎯 **Best practices** for clean, tested code

**Build amazing Laravel applications with React frontends, backed by comprehensive Pest tests!** 🚀

---

*Last updated: $(date)*  
*Environment Version: Laravel 12 + Pest 4 + React + Tailwind CSS*