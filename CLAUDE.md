# Development Environment Setup

This project provides a comprehensive development environment optimized for PHP/Laravel development with Tailwind CSS and React learning capabilities.

## Tech Stack Focus
- **Backend**: PHP 8+, Laravel 11+, Python 3+
- **Frontend**: Tailwind CSS, React/TypeScript  
- **Development**: Neovim with LSP, Claude Code integration, UV package manager

## Development Commands

### Laravel Commands
```bash
# Create new Laravel project
composer create-project laravel/laravel project-name

# Laravel development server
php artisan serve

# Run migrations
php artisan migrate

# Create model with migration
php artisan make:model ModelName -m

# Create controller
php artisan make:controller ControllerName

# Run tests
php artisan test
```

### Frontend Commands
```bash
# Install dependencies
npm install

# Development server with hot reload
npm run dev

# Build for production
npm run build

# Watch for changes
npm run watch
```

### Common Development Tasks
```bash
# Install PHP dependencies
composer install

# Update dependencies
composer update

# Code formatting (PHP CS Fixer)
./vendor/bin/php-cs-fixer fix

# Static analysis (PHPStan)
./vendor/bin/phpstan analyse

# Tailwind CSS build
npm run build-css
```

### Python Commands
```bash
# Install UV package manager (included in setup)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Create new Python project with UV
uv init my-project
cd my-project

# Install dependencies with UV
uv add fastapi uvicorn

# Create virtual environment and install dependencies
uv venv
source .venv/bin/activate  # Linux/macOS

# Run Python application
uv run python main.py

# Run tests
uv run pytest

# Install development dependencies
uv add --dev pytest black ruff
```

### Playwright Commands (Web Automation & Testing)
```bash
# Initialize Playwright in a new project
npx playwright init

# Run all tests
npx playwright test

# Run tests with UI mode for debugging
npx playwright test --ui

# Run specific test file
npx playwright test tests/example.spec.js

# Generate new test
npx playwright codegen

# Record test interactions
npx playwright codegen --target javascript https://example.com

# Run tests in headed mode (see browser)
npx playwright test --headed

# Generate HTML test report
npx playwright show-report

# Install additional browsers
npx playwright install firefox
npx playwright install webkit

# Update Playwright and browsers
npm update @playwright/test
npx playwright install
```

## Ansible Development Environment Commands

### Personal Configuration (Recommended First Step)
```bash
# Copy and customize your personal settings
cp personal-config.yml.example personal-config.yml
# Edit personal-config.yml with your git name, email, and preferences

# Run with personal configuration
ansible-playbook playbook.yml -e @personal-config.yml -K
```

### Initial Setup (First Time)
```bash
# Full development environment setup (with defaults)
ansible-playbook playbook.yml -K

# With custom configuration file
ansible-playbook playbook.yml -e @personal-config.yml -K

# Setup specific components only
ansible-playbook playbook.yml --tags neovim -K
ansible-playbook playbook.yml --tags laravel -K
ansible-playbook playbook.yml --tags python -K
ansible-playbook playbook.yml --tags playwright -K
ansible-playbook playbook.yml --tags zsh -K
```

### Configuration Updates
```bash
# Update only Neovim configuration files (after changes)
ansible-playbook update-config.yml -K

# This updates:
# - Plugin configurations
# - Key mappings  
# - Core settings
# - Snippets
# Without reinstalling packages or dependencies
```

### Ansible Project Structure
```
roles/
├── neovim/files/          # Source configuration files
│   ├── init.lua
│   ├── lua/core/          # Core Neovim settings
│   ├── lua/plugins/       # Plugin configurations
│   └── snippets/          # Code snippets
├── common-software/       # Base development tools
├── laravel/              # Laravel-specific setup
└── zsh/                  # Shell configuration

playbook.yml              # Main setup playbook
update-config.yml         # Quick config update playbook
inventory/hosts.yml       # Ansible inventory
```

## Neovim Key Bindings

### Laravel Specific (leader = space)
- `<leader>la` - Laravel Artisan commands
- `<leader>lr` - Laravel routes
- `<leader>lm` - Laravel related files

### GitHub Copilot (AI Code Suggestions)
- `Alt+l` - Accept Copilot suggestion
- `Alt+j` - Next suggestion
- `Alt+k` - Previous suggestion
- `Alt+h` - Dismiss suggestion
- `<leader>cp` - Toggle Copilot on/off

### LSP Functions
- `gd` - Go to definition
- `gr` - Go to references
- `K` - Show hover documentation
- `<leader>ca` - Code actions
- `<leader>rn` - Rename symbol

### File Navigation
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>fb` - Find buffers
- `<leader><leader>d` - Search dotfiles

## Snippet Triggers

### PHP/Laravel
- `controller` - Laravel controller template
- `model` - Laravel model template  
- `migration` - Laravel migration template
- `route` - Laravel route definition
- `livewire` - Livewire component
- `test` - PHPUnit test method

### React/TypeScript
- `rfc` - React functional component
- `useState` - useState hook
- `useEffect` - useEffect hook
- `context` - React context setup

### Python
- `def` - Python function template
- `class` - Python class template
- `main` - Python main guard
- `try` - Try-except block
- `for` - For loop
- `test` - Pytest test function
- `fastapi` - FastAPI route
- `flask` - Flask route

### Tailwind CSS
- `btn` - Button with Tailwind classes
- `card` - Card component
- `grid` - Responsive grid
- `flex-center` - Centered flex container

## Project Structure Conventions

### Laravel Project Structure
```
laravel-project/
├── app/
│   ├── Http/Controllers/     # API and web controllers
│   ├── Models/              # Eloquent models
│   └── Services/            # Business logic
├── resources/
│   ├── js/                  # React components
│   ├── css/                 # Tailwind CSS
│   └── views/               # Blade templates
├── tests/
│   ├── Feature/             # Feature tests
│   └── Unit/                # Unit tests
└── database/
    ├── migrations/          # Database migrations
    └── seeders/             # Database seeders
```

### Python Project Structure
```
python-project/
├── pyproject.toml           # UV/pip project configuration
├── uv.lock                  # UV lock file (like package-lock.json)
├── README.md               # Project documentation
├── .env                    # Environment variables
├── .gitignore              # Git ignore rules
├── src/
│   └── myproject/          # Main package
│       ├── __init__.py     # Package initialization
│       ├── main.py         # Application entry point
│       ├── models/         # Data models
│       ├── services/       # Business logic
│       ├── api/            # API routes (FastAPI/Flask)
│       └── utils/          # Utility functions
├── tests/
│   ├── __init__.py
│   ├── test_main.py        # Main tests
│   ├── unit/               # Unit tests
│   └── integration/        # Integration tests
├── docs/                   # Documentation
└── scripts/                # Utility scripts
```

## Development Workflow Tips

1. **Start Development Session**:
   - Open project in Neovim: `nvim .`
   - Start Laravel server: `php artisan serve`  
   - Start frontend build: `npm run dev`

2. **Code Quality**:
   - LSP provides real-time error checking
   - Use `:lua vim.lsp.buf.format()` to format code
   - Run tests frequently with `php artisan test`

3. **Claude Code Integration**:
   - Use Claude Code for complex refactoring
   - Switch to Neovim for rapid editing
   - Use `claude edit` for file-specific changes
   - Playwright MCP server enables web automation through Claude Code

## GitHub SSH Setup

### Initial Setup (Per Development Machine)
```bash
# Generate Ed25519 SSH key
ssh-keygen -t ed25519 -C "your-email@example.com" -f ~/.ssh/id_ed25519 -N ""

# Start SSH agent and add key
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Create SSH config
cat > ~/.ssh/config << EOF
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519
    IdentitiesOnly yes
EOF

chmod 600 ~/.ssh/config

# Configure Git identity
git config user.name "Your Name"
git config user.email "your-email@example.com"

# Display public key to add to GitHub
cat ~/.ssh/id_ed25519.pub
```

### Add to GitHub
1. Go to GitHub → Settings → SSH and GPG keys → New SSH key
2. Paste the public key content
3. Test connection: `ssh -T git@github.com`
4. Switch repo to SSH: `git remote set-url origin git@github.com:username/repo.git`

## Troubleshooting

### Common Issues
- **LSP not working**: Restart LSP with `:LspRestart`
- **Tailwind not updating**: Clear cache with `npm run build`
- **PHP errors**: Check `storage/logs/laravel.log`
- **SSH Permission denied**: Ensure public key is added to GitHub and SSH agent is running

### Performance Tips
- Use `:Telescope find_files` for large projects
- Enable persistent undo in Neovim
- Use Laravel Debugbar for performance monitoring