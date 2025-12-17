# 📚 Development Environment Documentation

Your complete guide to productive PHP/Laravel/React/Python development with Pest testing and Claude Code integration.

## 🚀 Getting Started

### Quick Setup
- **[🚀 Quick Start Guide](quick-start/getting-started.md)** - Get up and running in minutes
- **[🔧 Troubleshooting](quick-start/troubleshooting.md)** - Fix common issues fast

### First Steps
1. Run `ansible-playbook playbook.yml -K` to set up your environment
2. Create your first project: `laravel-new my-project react` or `uv init my-python-project`
3. Start developing: `dev-start` (Laravel) or `uv run python main.py` (Python)

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
- **[📦 Node.js with Mise](development/nodejs-mise.md)** - Node.js version management
  - Install multiple Node versions, per-project configurations
  - No more npm permission errors, automatic version switching

### 🐍 Python Development
- **[🐍 Python Development Guide](PYTHON_DEVELOPMENT.md)** - Complete Python development mastery
  - UV package manager (10-100x faster than pip), project structure, workflows
  - FastAPI, Flask, data science, testing with pytest, code quality tools
- **[⌨️  Neovim Python Integration](NEOVIM_PYTHON.md)** - Python in your editor
  - LSP features, code snippets, debugging, key bindings, advanced workflows

### 🤖 AI Development Tools
- **[🤖 Google Gemini CLI](development/gemini-cli.md)** - AI-assisted development
  - Chat with AI from terminal, code generation, file analysis
  - Debugging assistance, best practices, workflow integration

---

## ⚡ Quick Reference Cards

### 🎯 Essential Commands
| Task | Command |
|------|---------|
| **New Laravel Project** | `laravel-new project-name [react]` |
| **New Python Project** | `uv init project-name && cd project-name` |
| **Start Servers** | `dev-start` (Laravel), `uv run python main.py` (Python) |
| **Run Tests** | `pest` (Laravel), `uv run pytest` (Python) |
| **Node Version** | `mise use node@lts` (set version), `mise list` (show installed) |
| **AI Assistance** | `gemini chat "your question"` (Gemini), `cc` (Claude Code) |
| **Open Neovim** | `nv .` |

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

#### Python
- `def` → Function definition
- `class` → Class definition
- `main` → Main guard
- `test` → Pytest test
- `fastapi` → FastAPI route
- `flask` → Flask route

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
- **Python 3.x** with UV package manager (10-100x faster than pip)
- **Node.js** with mise version manager (multi-version support, no permission errors)
- **Neovim** with 30+ productivity plugins and full LSP support
- **Tailwind CSS** for rapid UI development
- **Claude Code** seamless integration
- **Zsh + Oh-My-Zsh** with productivity plugins

### 🎯 Optimized For
- **Laravel Development**: Controllers, models, migrations, API development
- **Python Development**: FastAPI, Flask, data science, CLI tools, testing with pytest
- **React Frontend**: Components, hooks, TypeScript, responsive design
- **Test-Driven Development**: Pest testing, pytest, mutation testing, coverage
- **Rapid Prototyping**: Language-specific snippets, auto-completion, hot reload
- **Code Quality**: Multi-language LSP integration, formatting, linting

---

## 🎉 Happy Coding!

Your development environment is configured for maximum productivity. Use this documentation as your daily reference for:

- ⚡ **Quick lookups** of shortcuts and commands
- 📚 **Deep dives** into specific technologies  
- 🔧 **Troubleshooting** when things go wrong
- 🎯 **Best practices** for clean, tested code

**Build amazing Laravel applications with React frontends, Python APIs and data tools, all backed by comprehensive testing!** 🚀

---

*Last updated: $(date)*  
*Environment Version: Laravel 12 + Pest 4 + Python + UV + React + Tailwind CSS*