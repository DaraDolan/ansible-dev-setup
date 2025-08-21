# 🚀 Laravel Deployment Guide

Deploy your Laravel applications with confidence using modern deployment strategies.

## 🎯 Quick Deployment Checklist

### Pre-Deployment
- [ ] All tests passing: `pest`
- [ ] Code formatted: `./vendor/bin/php-cs-fixer fix`
- [ ] Assets built: `npm run build`
- [ ] Environment configured: `.env.production`
- [ ] Database migrations ready: `php artisan migrate --dry-run`

### Production Deployment
- [ ] Zero-downtime deployment strategy
- [ ] Database backups created
- [ ] Cache optimization applied
- [ ] Queue workers configured
- [ ] Monitoring setup verified

## 🔧 Local Production Testing

```bash
# Test production build locally
php artisan config:cache
php artisan route:cache
php artisan view:cache
npm run build

# Run production server
php artisan serve --env=production

# Clear caches when done
php artisan config:clear
php artisan route:clear
php artisan view:clear
```

## 🐳 Docker Deployment

### Dockerfile
```dockerfile
FROM php:8.3-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git curl libpng-dev libonig-dev libxml2-dev zip unzip

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get install -y nodejs

# Set working directory
WORKDIR /var/www

# Copy composer files
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Copy package.json files  
COPY package.json package-lock.json ./
RUN npm ci --only=production

# Copy application code
COPY . .

# Build assets
RUN npm run build

# Set permissions
RUN chown -R www-data:www-data /var/www
RUN chmod -R 755 /var/www/storage

# Expose port
EXPOSE 9000

CMD ["php-fpm"]
```

### docker-compose.yml
```yaml
version: '3.8'

services:
  app:
    build: .
    container_name: laravel-app
    restart: unless-stopped
    working_dir: /var/www
    volumes:
      - ./:/var/www
      - ./docker/php/local.ini:/usr/local/etc/php/conf.d/local.ini
    networks:
      - laravel

  nginx:
    image: nginx:alpine
    container_name: laravel-nginx
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./:/var/www
      - ./docker/nginx:/etc/nginx/conf.d/
    networks:
      - laravel

  db:
    image: mysql:8.0
    container_name: laravel-db
    restart: unless-stopped
    environment:
      MYSQL_DATABASE: laravel
      MYSQL_ROOT_PASSWORD: secret
      MYSQL_PASSWORD: secret
      MYSQL_USER: laravel
    ports:
      - "3306:3306"
    volumes:
      - dbdata:/var/lib/mysql/
    networks:
      - laravel

  redis:
    image: redis:alpine
    container_name: laravel-redis
    restart: unless-stopped
    ports:
      - "6379:6379"
    networks:
      - laravel

networks:
  laravel:
    driver: bridge

volumes:
  dbdata:
    driver: local
```

## ☁️  Cloud Deployment

### Laravel Forge
```bash
# Deploy to Forge
forge deploy your-site-name

# Or configure auto-deployment
git push origin main  # Triggers automatic deployment
```

### Laravel Vapor (Serverless)
```bash
# Install Vapor CLI
composer global require laravel/vapor-cli

# Deploy to AWS Lambda
vapor deploy production
```

### DigitalOcean App Platform
```yaml
# .do/app.yaml
name: laravel-app
services:
- name: web
  source_dir: /
  github:
    repo: your-username/your-repo
    branch: main
  run_command: |
    php artisan migrate --force
    php artisan config:cache
    php artisan route:cache
    php artisan view:cache
  environment_slug: php
  instance_count: 1
  instance_size_slug: basic-xxs
  
- name: worker
  source_dir: /
  run_command: php artisan queue:work --sleep=3 --tries=3
  environment_slug: php
  instance_count: 1
  instance_size_slug: basic-xxs

databases:
- engine: MYSQL
  name: laravel-db
  num_nodes: 1
  size: basic-xs
```

## 🔄 Zero-Downtime Deployment

### Blue-Green Deployment Script
```bash
#!/bin/bash
# deploy.sh

set -e

# Configuration
REPO_URL="git@github.com:username/project.git"
PROJECT_ROOT="/var/www"
DOMAIN="yourapp.com"
BLUE_DIR="$PROJECT_ROOT/blue"
GREEN_DIR="$PROJECT_ROOT/green"

# Determine current and new deployment directories
if [ -L "$PROJECT_ROOT/current" ]; then
    CURRENT=$(readlink "$PROJECT_ROOT/current")
    if [ "$CURRENT" = "$BLUE_DIR" ]; then
        NEW_DIR="$GREEN_DIR"
    else
        NEW_DIR="$BLUE_DIR"
    fi
else
    NEW_DIR="$BLUE_DIR"
fi

echo "Deploying to: $NEW_DIR"

# Clone/update repository
if [ -d "$NEW_DIR" ]; then
    cd "$NEW_DIR"
    git pull origin main
else
    git clone "$REPO_URL" "$NEW_DIR"
    cd "$NEW_DIR"
fi

# Install dependencies
composer install --no-dev --optimize-autoloader
npm ci --only=production

# Build assets
npm run build

# Copy environment file
cp "$PROJECT_ROOT/.env" .env

# Run Laravel optimizations
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Run database migrations
php artisan migrate --force

# Switch symlink (zero-downtime switch)
ln -sfn "$NEW_DIR" "$PROJECT_ROOT/current"

# Reload PHP-FPM and Nginx
sudo systemctl reload php8.3-fpm
sudo systemctl reload nginx

# Queue restart
php artisan queue:restart

echo "Deployment complete! Now serving from: $NEW_DIR"

# Clean up old releases (keep last 3)
cd "$PROJECT_ROOT"
ls -dt */ | tail -n +4 | xargs rm -rf
```

## 📊 Performance Optimization

### Laravel Optimizations
```bash
# Production optimizations
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan event:cache

# OPcache configuration (php.ini)
opcache.enable=1
opcache.memory_consumption=128
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=4000
opcache.revalidate_freq=2
opcache.fast_shutdown=1
```

### Database Optimizations
```php
// config/database.php - Production MySQL config
'mysql' => [
    'driver' => 'mysql',
    'options' => [
        PDO::MYSQL_ATTR_USE_BUFFERED_QUERY => true,
        PDO::MYSQL_ATTR_INIT_COMMAND => "SET sql_mode='STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION'"
    ],
    'strict' => true,
    'charset' => 'utf8mb4',
    'collation' => 'utf8mb4_unicode_ci',
],
```

## 📈 Monitoring & Logging

### Application Monitoring
```php
// Install Laravel Telescope for debugging
composer require laravel/telescope --dev

// Install Sentry for error tracking
composer require sentry/sentry-laravel

// Install Laravel Horizon for queue monitoring
composer require laravel/horizon
```

### Server Monitoring
```bash
# Install monitoring tools
sudo apt install htop iotop nethogs

# Log monitoring with journalctl
journalctl -u nginx -f
journalctl -u php8.3-fpm -f

# Laravel logs
tail -f storage/logs/laravel.log
```

## 🔒 Security Checklist

### SSL/HTTPS
```bash
# Install Certbot for Let's Encrypt
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d yourapp.com
```

### Security Headers (Nginx)
```nginx
# /etc/nginx/sites-available/yourapp.com
server {
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self'" always;
    add_header Permissions-Policy "geolocation=(),midi=(),sync-xhr=(),microphone=(),camera=(),magnetometer=(),gyroscope=(),fullscreen=(self)" always;
}
```

### Laravel Security
```php
// config/app.php - Production settings
'debug' => false,
'key' => env('APP_KEY'),  // Make sure this is set!

// .env - Security settings  
APP_DEBUG=false
APP_URL=https://yourapp.com
SESSION_SECURE_COOKIE=true
SESSION_SAME_SITE=strict
```

## 📋 Deployment Automation

### GitHub Actions
```yaml
# .github/workflows/deploy.yml
name: Deploy to Production

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup PHP
      uses: shivammathur/setup-php@v2
      with:
        php-version: '8.3'
        
    - name: Install Dependencies
      run: |
        composer install --no-dev --optimize-autoloader
        npm ci --only=production
        
    - name: Run Tests
      run: vendor/bin/pest
      
    - name: Build Assets
      run: npm run build
      
    - name: Deploy to Server
      uses: appleboy/ssh-action@v0.1.5
      with:
        host: ${{ secrets.HOST }}
        username: ${{ secrets.USERNAME }}
        key: ${{ secrets.KEY }}
        script: |
          cd /var/www/yourapp
          ./deploy.sh
```

## 🎯 Best Practices

1. **Always test deployments** on staging first
2. **Backup database** before migrations
3. **Use feature flags** for gradual rollouts
4. **Monitor application** after deployment
5. **Keep deployment scripts** version controlled
6. **Document rollback procedures**
7. **Automate as much as possible**

---

**Deploy with confidence!** 🚀✨