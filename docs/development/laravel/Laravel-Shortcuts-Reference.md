# Laravel & Sail Shortcuts Reference

## Shell Aliases

### Laravel Sail
git log --oneline --since="1 week ago"
```bash
sail                    # Smart alias for ./sail or vendor/bin/sail
spf                     # sail test --filter (filter tests)
```

### Composer & Laravel
```bash
co                      # composer
ci                      # composer install
ptest                   # ./vendor/bin/pest
```

## Neovim Keybindings (leader = space)

### Laravel.nvim Plugin Features
| Shortcut | Command | Description |
|----------|---------|-------------|
| `<leader>la` | `:Laravel artisan` | Interactive Laravel artisan command picker |
| `<leader>lr` | `:Laravel routes` | Browse Laravel routes |
| `<leader>lm` | `:Laravel related` | Find related Laravel files |

### Sail Container Management
| Shortcut | Command | Description |
|----------|---------|-------------|
| `<leader>lsu` | `sail up -d` | Start Sail containers in background |
| `<leader>lsd` | `sail down` | Stop Sail containers |
| `<leader>lsr` | `sail restart` | Restart Sail containers |

### Sail Artisan Commands
| Shortcut | Command | Description |
|----------|---------|-------------|
| `<leader>lsa` | `sail artisan ` | Interactive Sail artisan command |
| `<leader>lst` | `sail test` | Run Sail tests |
| `<leader>lsm` | `sail artisan migrate` | Run Sail migrations |
| `<leader>lsf` | `sail artisan migrate:fresh --seed` | Fresh migration with seed |

### Sail Make Commands
| Shortcut | Command | Description |
|----------|---------|-------------|
| `<leader>lsc` | `sail artisan make:controller ` | Make controller via Sail |
| `<leader>lsmo` | `sail artisan make:model ` | Make model via Sail |
| `<leader>lsmi` | `sail artisan make:migration ` | Make migration via Sail |

### Regular Laravel (fallback for non-Sail projects)
| Shortcut | Command | Description |
|----------|---------|-------------|
| `<leader>lpa` | `php artisan ` | Interactive PHP artisan command |
| `<leader>lps` | `php artisan serve` | Start Laravel development server |
| `<leader>lpt` | `php artisan test` | Run Laravel tests |

### Laravel File Navigation
| Shortcut | Command | Description |
|----------|---------|-------------|
| `<leader>lfw` | `e routes/web.php` | Open web routes file |
| `<leader>lfa` | `e routes/api.php` | Open API routes file |
| `<leader>lfe` | `e .env` | Open environment file |
| `<leader>lfc` | `e config/app.php` | Open app config file |
| `<leader>lfd` | `e docker-compose.yml` | Open Docker compose file |

## Common Laravel Commands

### Development Workflow
```bash
# Start development environment
sail up -d              # Start containers
sail artisan serve      # Alternative: start Laravel server
npm run dev             # Start frontend development server

# Database operations
sail artisan migrate    # Run migrations
sail artisan migrate:fresh --seed  # Fresh migration with seeding
sail artisan db:seed    # Run database seeders

# Testing
sail test               # Run all tests
sail test --filter=TestName  # Run specific test
spf TestName           # Shortcut for filtered tests

# Code generation
sail artisan make:controller UserController
sail artisan make:model User -m  # With migration
sail artisan make:migration create_users_table
sail artisan make:request StoreUserRequest
sail artisan make:resource UserResource
sail artisan make:factory UserFactory
sail artisan make:seeder UserSeeder
```

### Container Management
```bash
# Container operations
sail up                 # Start containers (foreground)
sail up -d              # Start containers (background)
sail down               # Stop containers
sail restart            # Restart all containers
sail stop               # Stop containers (keep them)

# Individual services
sail mysql              # Access MySQL shell
sail redis              # Access Redis CLI
sail tinker             # Laravel Tinker REPL

# Logs and debugging
sail logs               # View all container logs
sail logs laravel.test  # View specific service logs
```

### Package Management
```bash
# PHP dependencies
sail composer install
sail composer update
sail composer require package/name

# Node dependencies
sail npm install
sail npm run dev
sail npm run build
sail npm run watch
```

### Maintenance
```bash
# Clear caches
sail artisan cache:clear
sail artisan config:clear
sail artisan route:clear
sail artisan view:clear

# Optimize for production
sail artisan config:cache
sail artisan route:cache
sail artisan view:cache
```

## Frontend Development

### Node/NPM Commands
| Shortcut | Command | Description |
|----------|---------|-------------|
| `<leader>nd` | `npm run dev` | Start npm dev server |
| `<leader>nb` | `npm run build` | Build for production |
| `<leader>ni` | `npm install` | Install npm dependencies |

### Tailwind CSS
| Shortcut | Command | Description |
|----------|---------|-------------|
| `<leader>tw` | `npx tailwindcss init` | Initialize Tailwind CSS |

## Quick Reference

### Most Used Sail Commands
```bash
sail up -d              # Start development environment
sail down               # Stop environment
sail artisan migrate    # Run database migrations
sail test               # Run tests
sail composer install   # Install PHP dependencies
sail npm run dev        # Start frontend development
```

### Most Used Neovim Shortcuts
```bash
<space>lsu              # Start Sail containers
<space>lsd              # Stop Sail containers
<space>lsa              # Interactive artisan command
<space>lst              # Run tests
<space>lsm              # Run migrations
<space>la               # Laravel artisan picker (plugin)
<space>lr               # Browse routes (plugin)
```

## Tips

1. **Use the `sail` alias** - Works from any directory in your Laravel project
2. **Interactive commands** - Commands ending with a space (like `<leader>lsa`) wait for your input
3. **Plugin vs Manual** - Use `<leader>la` for Laravel.nvim's interactive picker, or `<leader>lsa` for direct sail commands
4. **File navigation** - Use `<leader>lf*` shortcuts to quickly open Laravel files
5. **Container logs** - Use `sail logs` to debug container issues
6. **Database access** - Use `sail mysql` or `sail tinker` for database operations

## Project Structure Reminder
```
laravel-project/
├── app/Http/Controllers/     # <leader>lsc for new controllers
├── app/Models/              # <leader>lsmo for new models
├── database/migrations/     # <leader>lsmi for new migrations
├── routes/web.php           # <leader>lfw to open
├── routes/api.php           # <leader>lfa to open
├── .env                     # <leader>lfe to open
└── docker-compose.yml       # <leader>lfd to open
```
