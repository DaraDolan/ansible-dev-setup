#!/bin/bash

# Development Environment Setup Script
# Optimized for PHP/Laravel + React development with Claude Code integration

set -e

echo "🚀 Setting up your PHP/Laravel/React development environment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on WSL2
if grep -q Microsoft /proc/version; then
    print_status "Detected WSL2 environment"
    IS_WSL=true
else
    IS_WSL=false
fi

# Update system packages
print_status "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install essential packages
print_status "Installing essential development packages..."
sudo apt install -y \
    git curl wget build-essential zsh \
    python3 python3-pip python3-venv \
    nodejs npm \
    software-properties-common apt-transport-https ca-certificates

# Install PHP and related packages
print_status "Installing PHP and related packages..."
sudo apt install -y \
    php php-cli php-fpm php-json php-common php-mysql \
    php-zip php-gd php-mbstring php-curl php-xml \
    php-pear php-bcmath php-tokenizer php-xmlwriter \
    php-simplexml php-dom php-fileinfo

# Install Composer
if ! command -v composer &> /dev/null; then
    print_status "Installing Composer..."
    curl -sS https://getcomposer.org/installer | php
    sudo mv composer.phar /usr/local/bin/composer
    sudo chmod +x /usr/local/bin/composer
    print_success "Composer installed successfully"
else
    print_success "Composer already installed"
fi

# Install Node.js LTS via NodeSource
print_status "Installing Node.js LTS..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install global npm packages for development
print_status "Installing global npm packages..."
sudo npm install -g \
    @tailwindcss/cli \
    typescript \
    @types/node \
    prettier \
    eslint \
    create-react-app \
    vite

# Install Neovim if not present
if ! command -v nvim &> /dev/null; then
    print_status "Installing Neovim..."
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod u+x nvim.appimage
    sudo mv nvim.appimage /usr/local/bin/nvim
    print_success "Neovim installed successfully"
else
    print_success "Neovim already installed"
fi

# Setup Zsh and Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_status "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install Zinit for Zsh plugin management
if [ ! -d "$HOME/.local/share/zinit" ]; then
    print_status "Installing Zinit..."
    bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
fi

# Copy configuration files
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$SCRIPT_DIR")"

print_status "Setting up Neovim configuration..."
mkdir -p ~/.config/nvim
cp -r "$CONFIG_DIR/roles/neovim/files/"* ~/.config/nvim/

print_status "Setting up Zsh configuration..."
cp "$CONFIG_DIR/roles/zsh/files/zshrc" ~/.zshrc
cp "$CONFIG_DIR/roles/zsh/files/p10k.zsh" ~/.p10k.zsh
cp "$CONFIG_DIR/roles/zsh/files/zinit.zsh" ~/.zinit.zsh

# Set Zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    print_status "Setting Zsh as default shell..."
    chsh -s $(which zsh)
    print_warning "Please log out and log back in for shell change to take effect"
fi

# Create development directory structure
print_status "Creating development directory structure..."
mkdir -p ~/development/{php,laravel,react,projects}

# Install Laravel installer globally
if ! command -v laravel &> /dev/null; then
    print_status "Installing Laravel installer..."
    composer global require laravel/installer
    
    # Add Composer global bin to PATH if not already there
    if ! grep -q 'composer/vendor/bin' ~/.bashrc; then
        echo 'export PATH="$HOME/.config/composer/vendor/bin:$PATH"' >> ~/.bashrc
    fi
    
    if ! grep -q 'composer/vendor/bin' ~/.zshrc; then
        echo 'export PATH="$HOME/.config/composer/vendor/bin:$PATH"' >> ~/.zshrc
    fi
    
    print_success "Laravel installer installed globally"
else
    print_success "Laravel installer already available"
fi

# Create aliases for seamless Claude Code integration
print_status "Setting up development aliases..."
cat >> ~/.zshrc << 'EOF'

# Development aliases for seamless workflow
alias cc='claude'
alias cce='claude edit'
alias nv='nvim'
alias art='php artisan'
alias serve='php artisan serve'
alias tinker='php artisan tinker'
alias migrate='php artisan migrate'
alias fresh='php artisan migrate:fresh --seed'
alias test='php artisan test'

# Quick project navigation
alias dev='cd ~/development'
alias projects='cd ~/development/projects'

# Laravel project shortcuts
laravel-new() {
    if [ -z "$1" ]; then
        echo "Usage: laravel-new project-name [react]"
        return 1
    fi
    
    cd ~/development/projects
    
    # Create Laravel project with Pest testing
    laravel new $1 --pest --git
    cd $1
    
    # Setup Tailwind CSS
    npm install -D tailwindcss postcss autoprefixer
    npx tailwindcss init -p
    
    # Update Tailwind config for Laravel
    cat > tailwind.config.js << 'EOF'
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./resources/**/*.blade.php",
    "./resources/**/*.js",
    "./resources/**/*.jsx",
    "./resources/**/*.tsx",
    "./resources/**/*.vue",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOF
    
    # Add Tailwind to CSS
    cat > resources/css/app.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF
    
    # Setup basic React if requested
    if [ "$2" = "react" ]; then
        npm install react react-dom @types/react @types/react-dom
        npm install -D @vitejs/plugin-react typescript
        
        # Update Vite config for React
        cat > vite.config.js << 'EOF'
import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';
import react from '@vitejs/plugin-react';

export default defineConfig({
    plugins: [
        laravel({
            input: ['resources/css/app.css', 'resources/js/app.jsx'],
            refresh: true,
        }),
        react(),
    ],
});
EOF
        
        # Create basic React component
        mkdir -p resources/js/components
        cat > resources/js/components/Welcome.jsx << 'EOF'
import React from 'react';

export default function Welcome({ user }) {
    return (
        <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 flex items-center justify-center">
            <div className="max-w-md w-full bg-white rounded-lg shadow-lg p-8">
                <h1 className="text-3xl font-bold text-gray-900 mb-4">
                    Welcome to Laravel + React!
                </h1>
                <p className="text-gray-600 mb-6">
                    Your development environment is ready with Pest testing, Tailwind CSS, and React.
                </p>
                {user && (
                    <p className="text-sm text-indigo-600">
                        Hello, {user.name}! 👋
                    </p>
                )}
            </div>
        </div>
    );
}
EOF
        
        # Update main JS file
        cat > resources/js/app.jsx << 'EOF'
import React from 'react';
import { createRoot } from 'react-dom/client';
import Welcome from './components/Welcome';
import '../css/app.css';

const container = document.getElementById('app');
const root = createRoot(container);
root.render(<Welcome />);
EOF
    fi
    
    # Install additional testing packages for better Pest experience
    composer require --dev pestphp/pest-plugin-laravel pestphp/pest-plugin-faker
    
    # Create sample Pest test
    cat > tests/Feature/ExampleTest.php << 'EOF'
<?php

use App\Models\User;

it('has welcome page', function () {
    $response = $this->get('/');
    $response->assertStatus(200);
});

it('can create users', function () {
    $user = User::factory()->create([
        'name' => 'John Doe',
        'email' => 'john@example.com',
    ]);

    expect($user->name)->toBe('John Doe');
    expect($user->email)->toBe('john@example.com');
});

it('can authenticate users', function () {
    $user = User::factory()->create();

    $this->actingAs($user)
         ->get('/dashboard')
         ->assertStatus(200);
});
EOF

    # Create Unit test example
    cat > tests/Unit/ExampleTest.php << 'EOF'
<?php

it('returns true', function () {
    expect(true)->toBeTrue();
});

it('can perform basic math', function () {
    expect(2 + 2)->toBe(4);
    expect(10 / 2)->toBe(5);
});

it('can work with arrays', function () {
    $array = ['laravel', 'pest', 'tailwind'];
    
    expect($array)
        ->toHaveCount(3)
        ->toContain('pest');
});
EOF
    
    echo "🎉 Laravel project '$1' created successfully with Pest testing!"
    echo "📁 Location: ~/development/projects/$1"
    echo ""
    echo "🚀 Quick start:"
    echo "  cd ~/development/projects/$1"
    echo "  php artisan serve    # Start Laravel server"
    echo "  npm run dev          # Start Vite dev server"  
    echo "  php artisan test     # Run Pest tests"
    echo ""
    if [ "$2" = "react" ]; then
        echo "⚛️  React setup complete!"
        echo "  Edit resources/js/components/ for React components"
    fi
    echo "🎨 Tailwind CSS configured and ready"
    echo "🧪 Pest testing framework installed with sample tests"
}

# Quick development server startup
dev-start() {
    if [ -f "artisan" ]; then
        echo "Starting Laravel development server..."
        php artisan serve &
        LARAVEL_PID=$!
        
        if [ -f "package.json" ] && grep -q "vite" package.json; then
            echo "Starting Vite development server..."
            npm run dev &
            VITE_PID=$!
        fi
        
        echo "Development servers started!"
        echo "Laravel: http://localhost:8000"
        echo "Vite: http://localhost:5173"
        echo ""
        echo "Press Ctrl+C to stop all servers"
        
        trap "kill $LARAVEL_PID $VITE_PID 2>/dev/null" INT
        wait
    else
        echo "Not in a Laravel project directory"
    fi
}

# Claude Code integration helpers
claude-project() {
    echo "Opening current project in Claude Code..."
    claude .
}

claude-nvim() {
    if [ -n "$1" ]; then
        echo "Editing $1 with Claude Code, then opening in Neovim..."
        claude edit "$1"
        nvim "$1"
    else
        echo "Usage: claude-nvim filename"
    fi
}
EOF

print_success "Development aliases added to ~/.zshrc"

# Install Lazy.nvim plugin manager if not present
print_status "Setting up Neovim plugins..."
if [ ! -d ~/.local/share/nvim/lazy ]; then
    git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable ~/.local/share/nvim/lazy/lazy.nvim
fi

# Create a development workflow guide
print_status "Creating development workflow guide..."
cat > ~/development/WORKFLOW.md << 'EOF'
# Development Workflow Guide

## Daily Development Routine

### 1. Start Your Development Session
```bash
# Navigate to your project
cd ~/development/projects/your-project

# Start development servers
dev-start

# Open in Neovim for editing
nv .

# Or open in Claude Code for AI assistance
cc
```

### 2. Common Development Tasks

#### Laravel Development
```bash
# Create new Laravel project with React
laravel-new my-project react

# Common artisan commands
art make:model Post -m     # Model with migration
art make:controller PostController --resource
art migrate
art test
```

#### Frontend Development
```bash
# Install and setup Tailwind
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p

# Start frontend development
npm run dev
```

### 3. Seamless Editor Switching
```bash
# Edit with Claude Code then continue in Neovim
claude-nvim app/Models/User.php

# Quick Claude Code session
claude-project

# Direct Neovim editing
nv app/Http/Controllers/
```

### 4. Code Quality
```bash
# Format PHP code
./vendor/bin/php-cs-fixer fix

# Run tests
test

# Type checking (if using PHPStan)
./vendor/bin/phpstan analyse
```

## Key Productivity Tips

1. **Use Snippets**: Type 'controller', 'model', 'rfc' in Neovim for instant templates
2. **LSP Power**: Use 'gd' for go-to-definition, 'gr' for references
3. **Telescope**: '<leader>ff' for file search, '<leader>fg' for content search
4. **Laravel Plugin**: '<leader>la' for artisan, '<leader>lr' for routes
5. **Git Integration**: Stage hunks with '<leader>hs', blame with '<leader>hb'

## Project Structure Best Practices

```
your-laravel-project/
├── app/
│   ├── Http/Controllers/    # Keep controllers thin
│   ├── Models/             # Eloquent models with relationships
│   ├── Services/           # Business logic here
│   └── Policies/           # Authorization logic
├── resources/
│   ├── js/                 # React components
│   │   ├── Components/     # Reusable components
│   │   ├── Pages/          # Page components
│   │   └── Hooks/          # Custom React hooks
│   ├── css/                # Tailwind CSS files
│   └── views/              # Blade templates
├── tests/
│   ├── Feature/            # End-to-end tests
│   └── Unit/               # Unit tests
└── database/
    ├── migrations/         # Database schema
    ├── factories/          # Model factories
    └── seeders/            # Sample data
```
EOF

print_success "✨ Development environment setup complete!"

echo ""
echo "🎉 Your PHP/Laravel/React development environment is ready!"
echo ""
echo "Next steps:"
echo "1. Run 'source ~/.zshrc' or restart your terminal"
echo "2. Create a new Laravel project: 'laravel-new my-project react'"
echo "3. Start development: 'cd ~/development/projects/my-project && dev-start'"
echo "4. Open in Neovim: 'nv .' or Claude Code: 'cc'"
echo ""
echo "📖 Check ~/development/WORKFLOW.md for detailed usage guide"
echo "🔧 All configuration files are in ~/.config/nvim/"
echo ""
print_success "Happy coding! 🚀"