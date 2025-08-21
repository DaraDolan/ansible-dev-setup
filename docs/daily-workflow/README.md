# 📅 Daily Development Workflow

Your complete guide to productive daily development with Laravel, React, and Pest.

## 🌅 Morning Routine

### 1. Start Development Session
```bash
# Navigate to your project
cd ~/development/projects/your-project

# Start all servers
dev-start
# This starts:
# - Laravel development server (port 8000)
# - Vite dev server (port 5173)
# - File watchers for hot reload
```

### 2. Open Your Editors
```bash
# Option 1: Neovim for focused coding
nv .

# Option 2: Claude Code for AI assistance
cc

# Option 3: Both (recommended workflow)
cc &  # Claude Code in background
nv .  # Neovim in foreground
```

## 🔄 Development Cycle

### Code → Test → Refactor Loop

```bash
# 1. Write code in Neovim
nv app/Models/User.php

# 2. Run tests continuously
pest --watch

# 3. Use Claude Code for complex refactoring
claude edit app/Services/UserService.php

# 4. Back to Neovim for quick edits
```

## ⌨️  Essential Daily Shortcuts

### Neovim Quick Actions
| Shortcut | Action |
|----------|---------|
| `<leader>ff` | Find files |
| `<leader>fg` | Search content |
| `<leader>la` | Laravel artisan |
| `<leader>lt` | Run tests |
| `<leader>cc` | Claude Code |
| `gd` | Go to definition |
| `<leader>ca` | Code actions |

### Terminal Aliases
| Alias | Command | Purpose |
|-------|---------|----------|
| `art` | `php artisan` | Laravel commands |
| `pest` | `./vendor/bin/pest` | Run tests |
| `serve` | `php artisan serve` | Start server |
| `fresh` | `php artisan migrate:fresh --seed` | Reset DB |

## 🧪 Testing Workflow

### Test-Driven Development
```bash
# 1. Write failing test
nv tests/Feature/UserCanCreatePostTest.php
# Type 'pestfeature' + Tab for template

# 2. Run test to see it fail
pest --filter="user can create post"

# 3. Write minimal code to pass
nv app/Http/Controllers/PostController.php

# 4. Run test again
pest --filter="user can create post"

# 5. Refactor if needed
```

### Test Commands
```bash
# Run all tests
pest

# Run specific test file
pest tests/Feature/PostTest.php

# Run tests with coverage
pest --coverage

# Watch mode (auto-run on file changes)
pest --watch

# Mutation testing (validate test quality)
pest --mutate
```

## 🎨 Frontend Development

### React Component Workflow
```bash
# 1. Create component
nv resources/js/components/PostCard.jsx
# Type 'rfc' + Tab for React component template

# 2. Add Tailwind styling
# Type 'card' + Tab for Tailwind card template

# 3. Test in browser
# Vite auto-reloads on save

# 4. Build for production
npm run build
```

### CSS Development
```bash
# Watch Tailwind changes
npm run dev

# Build optimized CSS
npm run build

# Purge unused styles
npm run build -- --purge
```

## 🔀 Git Workflow

### Daily Git Commands
```bash
# Morning: Pull latest changes
git pull origin main

# Feature development
git checkout -b feature/user-posts
git add .
git commit -m "Add user posts functionality"

# Push changes
git push origin feature/user-posts

# Evening: Clean up
git checkout main
git pull origin main
```

### Neovim Git Integration
| Shortcut | Action |
|----------|---------|
| `<leader>G` | Git status |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hp` | Preview hunk |
| `]c` / `[c` | Next/prev hunk |

## 🚀 Deployment Workflow

### Pre-deployment Checklist
```bash
# 1. Run full test suite
pest

# 2. Check code quality
./vendor/bin/php-cs-fixer fix --dry-run

# 3. Security audit
composer audit

# 4. Build assets
npm run build

# 5. Check environment
php artisan config:cache
php artisan route:cache
```

## 🌙 End of Day Routine

### Cleanup & Commit
```bash
# 1. Review changes
git status
git diff

# 2. Commit work
git add .
git commit -m "End of day: feature progress"

# 3. Push to remote
git push origin feature-branch

# 4. Stop servers
# Ctrl+C in dev-start terminal
```

## 📊 Weekly Review

### Performance & Quality Check
```bash
# Run comprehensive tests
pest --coverage --mutate

# Check dependencies
composer outdated
npm audit

# Review metrics
git log --oneline --since="1 week ago"
```

## 🎯 Productivity Tips

1. **Use Snippets**: Type `controller`, `model`, `pest`, `rfc` for instant templates
2. **Keep Tests Running**: Use `pest --watch` during development  
3. **LSP Power**: Use `gd`, `gr`, `K` for code navigation
4. **Claude Integration**: Use `<leader>cc` for complex refactoring
5. **Terminal Management**: Keep multiple terminals with tmux or terminal tabs

## 📚 Related Guides

- [⌨️  Neovim Keybindings](../neovim/keybindings.md)
- [🧪 Pest Testing Guide](../testing/pest-guide.md)  
- [⚛️  React Development](../frontend/react-setup.md)
- [🚀 Deployment Guide](../deployment/laravel-deploy.md)

---

**Happy productive coding!** 🎉