# 🔧 Troubleshooting Guide

Quick fixes for common issues in your development environment.

## 🚨 Common Issues

### Laravel Not Found
```bash
# Problem: 'laravel' command not found
# Solution: Add Composer bin to PATH
export PATH="$HOME/.config/composer/vendor/bin:$PATH"
echo 'export PATH="$HOME/.config/composer/vendor/bin:$PATH"' >> ~/.zshrc
```

### Neovim Plugin Errors
```bash
# Problem: Plugins not loading
# Solution: Reinstall plugins
rm -rf ~/.local/share/nvim/
nvim +PackerSync +qall
```

### Laravel Server Won't Start
```bash
# Problem: Port 8000 already in use
# Solution: Use different port
php artisan serve --port=8001

# Or kill existing process
lsof -ti:8000 | xargs kill -9
```

### Vite Build Errors
```bash
# Problem: Frontend build failing
# Solution: Clear cache and reinstall
rm -rf node_modules package-lock.json
npm install
npm run dev
```

### Database Connection Issues
```bash
# Problem: Database connection refused
# Solution: Check Laravel environment
cp .env.example .env
php artisan key:generate
php artisan migrate
```

## ⚡ Quick Fixes

### Reset Everything
```bash
# Nuclear option - reset entire project
rm -rf node_modules vendor
composer install
npm install
php artisan key:generate
php artisan migrate:fresh --seed
```

### Test Issues
```bash
# Problem: Pest tests failing
# Solution: Clear config cache
php artisan config:clear
php artisan cache:clear
pest --coverage
```

### Permission Problems
```bash
# Problem: Permission denied errors
# Solution: Fix Laravel permissions
sudo chown -R $USER:$USER storage bootstrap/cache
chmod -R 775 storage bootstrap/cache
```

## 🔍 Debugging Commands

```bash
# Check system status
./test-setup.sh

# Verify Laravel installation
php artisan --version
composer show

# Check Node.js setup
node --version
npm list -g --depth=0

# Test Neovim config
nvim --version
nvim +checkhealth +qall
```

## 📞 Getting Help

1. **Run Tests**: `./test-setup.sh`
2. **Check Logs**: `tail -f storage/logs/laravel.log`
3. **Laravel Debug**: Enable `APP_DEBUG=true` in `.env`
4. **Neovim Health**: `:checkhealth` in Neovim

## 🆘 Emergency Reset

If nothing works, reset your environment:

```bash
# Backup your projects
cp -r ~/development/projects ~/projects-backup

# Run setup again
cd /home/dara/development/ansible-dev-setup
./scripts/dev-setup.sh

# Restore projects
cp -r ~/projects-backup/* ~/development/projects/
```