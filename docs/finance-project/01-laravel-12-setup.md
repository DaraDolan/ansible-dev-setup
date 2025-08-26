# Laravel 12.x + React Setup Guide

## 🎯 Goal
Set up a fresh Laravel 12.x project with React 19 + TypeScript starter kit.

## 📋 Prerequisites

Ensure you have:
- PHP 8.4+ installed
- Composer installed  
- Laravel installer
- Node.js and npm

## 🚀 Step-by-Step Setup

### 1. Install Laravel 12.x with React Starter Kit

```bash
# Create new Laravel 12.x project with React starter kit
composer create-project laravel/laravel portfolio-tracker-pro
cd portfolio-tracker-pro

# Or using Laravel installer (if you have it)
laravel new portfolio-tracker-pro
```

**🎮 Neovim Tip**: Open the project in Neovim:
```bash
nvim .
```
You'll see your beautiful Alpha dashboard! 

### 2. Choose React Starter Kit During Setup

During Laravel installation, you'll be prompted to choose:
- **Starter kit**: Select **React** (React 19 + TypeScript + Tailwind + shadcn/ui)
- **Testing framework**: Select **Pest**
- **Database**: Select **SQLite** for development

### 3. Install Dependencies

```bash
# Install PHP dependencies
composer install

# Install Node.js dependencies (React, TypeScript, Tailwind)
npm install

# Build frontend assets
npm run build
```

### 4. Environment Setup

Copy and configure your environment:
```bash
cp .env.example .env
php artisan key:generate
```

**🎮 Neovim Shortcut**: 
- Press `<leader>le` to quickly open `.env` file
- Use the `env` snippet to add new environment variables

### 5. Database Setup

```bash
# Create SQLite database (default in Laravel 12)
touch database/database.sqlite

# Run initial migrations
php artisan migrate
```

### 6. Start Development Servers

Open **two terminals** (or use ToggleTerm):

**Terminal 1** - Laravel server:
```bash
php artisan serve
# Runs on http://localhost:8000
```

**Terminal 2** - Vite dev server:
```bash
npm run dev
# Runs on http://localhost:5173 (proxies to Laravel)
```

**🎮 Neovim Shortcuts**:
- `<C-\>` - Open floating terminal
- `<leader>th` - Horizontal terminal
- `<leader>tv` - Vertical terminal

### 7. Verify Installation

Visit `http://localhost:8000` - you should see:
- Beautiful Laravel welcome page
- React components working
- Tailwind CSS styling
- TypeScript compilation

## 📁 Project Structure Overview

Laravel 12.x with React gives you:

```
portfolio-tracker-pro/
├── app/
│   ├── Http/Controllers/     # Laravel controllers
│   ├── Models/              # Eloquent models
│   └── Providers/           # Service providers
├── database/
│   ├── migrations/          # Database migrations
│   └── seeders/             # Database seeders  
├── resources/
│   ├── js/                  # React TypeScript files
│   │   ├── Components/      # React components
│   │   ├── Pages/           # Inertia pages
│   │   └── types/           # TypeScript types
│   ├── css/                 # Tailwind CSS
│   └── views/               # Blade templates
├── routes/
│   ├── web.php              # Web routes (Inertia)
│   └── api.php              # API routes
└── tests/                   # Pest tests
```

## 🎮 Essential Neovim Workflows

**File Navigation**:
- `<leader>f` - Find files in project
- `<leader>a` - Add current file to Harpoon
- `<leader>1-4` - Quick jump to harpoon files
- `<leader>e` - Neo-tree file explorer
- `<leader>o` - Oil.nvim alternative file manager

**Code Intelligence**:
- `gd` - Go to definition
- `gr` - Find references  
- `K` - Show documentation
- `<leader>ca` - Code actions
- `<leader>rn` - Rename symbol

**Laravel Specific**:
- Type `controller` and press Tab - Laravel controller snippet
- Type `model` and press Tab - Laravel model snippet  
- Type `migration` and press Tab - Laravel migration snippet

**React/TypeScript**:
- Type `rfc` and press Tab - React functional component
- Type `useState` and press Tab - React useState hook
- Type `btn` and press Tab - Button component with Tailwind

## 📝 Quick Test

Let's verify everything works:

1. **Open Neovim in project root**:
   ```bash
   nvim .
   ```

2. **Create a test controller**:
   - Press `<leader>f` to find files
   - Type `app/Http/Controllers` and create new file
   - Type `controller` + Tab to use snippet

3. **Create a React component**:
   - Navigate to `resources/js/Components`
   - Create new `.tsx` file
   - Type `rfc` + Tab for React component snippet

4. **Use Git integration**:
   - Press `<leader>gg` for LazyGit
   - Stage and commit your initial setup

## ✅ Success Criteria

You should have:
- ✅ Laravel 12.x running on localhost:8000
- ✅ React with TypeScript compiling
- ✅ Tailwind CSS working
- ✅ Neovim with beautiful syntax highlighting
- ✅ All LSP features working (go to definition, etc.)
- ✅ Git repository initialized

## 🐛 Troubleshooting

**Common issues**:

**PHP version error**:
```bash
php --version  # Should be 8.4+
```

**Composer errors**:
```bash
composer install --no-dev --optimize-autoloader
```

**NPM/Node issues**:
```bash
node --version  # Should be 18+
npm cache clean --force
npm install
```

**Neovim LSP not working**:
- Press `:checkhealth` in Neovim
- Ensure Mason has installed language servers
- Try `:LspRestart`

## 🎯 Next Steps

With Laravel 12.x + React setup complete, proceed to:
**[02-database-auth-permissions.md](./02-database-auth-permissions.md)** - Set up authentication and permissions

Your foundation is ready! Let's build something amazing! 🚀