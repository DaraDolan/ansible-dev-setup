# Development Environment Setup

This project provides a comprehensive development environment optimized for PHP/Laravel development with Tailwind CSS and React learning capabilities.

## Tech Stack Focus
- **Backend**: PHP 8+, Laravel 11+
- **Frontend**: Tailwind CSS, React/TypeScript
- **Development**: Neovim with LSP, Claude Code integration

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

## Neovim Key Bindings

### Laravel Specific (leader = space)
- `<leader>la` - Laravel Artisan commands
- `<leader>lr` - Laravel routes
- `<leader>lm` - Laravel related files

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

### Tailwind CSS
- `btn` - Button with Tailwind classes
- `card` - Card component
- `grid` - Responsive grid
- `flex-center` - Centered flex container

## Project Structure Conventions
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