#!/bin/bash

# Test script for development environment setup
# This script validates that all components are working correctly

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_test() {
    echo -e "${BLUE}[TEST]${NC} $1"
}

print_pass() {
    echo -e "${GREEN}[PASS]${NC} $1"
}

print_fail() {
    echo -e "${RED}[FAIL]${NC} $1"
}

print_info() {
    echo -e "${YELLOW}[INFO]${NC} $1"
}

echo "🧪 Testing Development Environment Setup"
echo "========================================"
echo

# Test 1: Check essential commands
print_test "Checking essential commands..."

commands=("git" "curl" "wget" "php" "composer" "node" "npm" "nvim" "zsh")
for cmd in "${commands[@]}"; do
    if command -v "$cmd" &> /dev/null; then
        version=$(eval "$cmd --version 2>/dev/null | head -n1" || echo "unknown")
        print_pass "$cmd is installed ($version)"
    else
        print_fail "$cmd is not installed"
    fi
done

echo

# Test 2: Check PHP extensions
print_test "Checking PHP extensions..."

php_extensions=("json" "curl" "mbstring" "xml" "zip" "gd" "mysql" "bcmath")
for ext in "${php_extensions[@]}"; do
    if php -m | grep -q "$ext"; then
        print_pass "PHP extension '$ext' is loaded"
    else
        print_fail "PHP extension '$ext' is missing"
    fi
done

echo

# Test 3: Check Composer global packages
print_test "Checking Composer global packages..."

if command -v laravel &> /dev/null; then
    print_pass "Laravel installer is available globally"
else
    print_fail "Laravel installer is not available globally"
    print_info "Run: composer global require laravel/installer"
fi

echo

# Test 4: Check Node.js global packages
print_test "Checking Node.js global packages..."

node_packages=("tailwindcss" "typescript" "prettier" "eslint")
for pkg in "${node_packages[@]}"; do
    if npm list -g "$pkg" &> /dev/null; then
        print_pass "npm package '$pkg' is installed globally"
    else
        print_fail "npm package '$pkg' is missing"
        print_info "Run: npm install -g $pkg"
    fi
done

echo

# Test 5: Check Neovim configuration
print_test "Checking Neovim configuration..."

if [ -d "$HOME/.config/nvim" ]; then
    print_pass "Neovim config directory exists"
    
    if [ -f "$HOME/.config/nvim/init.lua" ]; then
        print_pass "Neovim init.lua found"
    else
        print_fail "Neovim init.lua missing"
    fi
    
    if [ -d "$HOME/.config/nvim/lua" ]; then
        print_pass "Neovim Lua configuration directory found"
    else
        print_fail "Neovim Lua configuration directory missing"
    fi
    
    if [ -d "$HOME/.config/nvim/snippets" ]; then
        print_pass "Neovim snippets directory found"
    else
        print_fail "Neovim snippets directory missing"
    fi
else
    print_fail "Neovim config directory missing"
fi

echo

# Test 6: Check Zsh configuration
print_test "Checking Zsh configuration..."

if [ -f "$HOME/.zshrc" ]; then
    print_pass "Zsh configuration file found"
else
    print_fail "Zsh configuration file missing"
fi

if [ -d "$HOME/.oh-my-zsh" ]; then
    print_pass "Oh-My-Zsh is installed"
else
    print_fail "Oh-My-Zsh is missing"
fi

if [ -d "$HOME/.local/share/zinit" ]; then
    print_pass "Zinit is installed"
else
    print_fail "Zinit is missing"
fi

echo

# Test 7: Check development directories
print_test "Checking development directory structure..."

dev_dirs=("$HOME/development" "$HOME/development/php" "$HOME/development/laravel" "$HOME/development/react" "$HOME/development/projects")
for dir in "${dev_dirs[@]}"; do
    if [ -d "$dir" ]; then
        print_pass "Directory $dir exists"
    else
        print_fail "Directory $dir missing"
    fi
done

echo

# Test 8: Test Neovim plugins (if Neovim is available)
print_test "Testing Neovim basic functionality..."

if command -v nvim &> /dev/null; then
    # Test if Neovim can start and load basic config
    if nvim --headless -c 'quitall' &> /dev/null; then
        print_pass "Neovim starts successfully"
    else
        print_fail "Neovim fails to start"
    fi
else
    print_fail "Neovim is not available"
fi

echo

# Test 9: Test creating a sample Laravel project
print_test "Testing Laravel project creation..."

test_project_dir="/tmp/test-laravel-project"
if [ -d "$test_project_dir" ]; then
    rm -rf "$test_project_dir"
fi

if command -v laravel &> /dev/null; then
    print_info "Creating test Laravel project (this may take a moment)..."
    cd /tmp
    if laravel new test-laravel-project --quiet; then
        print_pass "Laravel project created successfully"
        
        cd test-laravel-project
        
        # Test if artisan works
        if php artisan --version &> /dev/null; then
            print_pass "Laravel Artisan is working"
        else
            print_fail "Laravel Artisan is not working"
        fi
        
        # Test if we can install npm dependencies
        if [ -f "package.json" ]; then
            print_pass "Laravel project includes frontend scaffolding"
        else
            print_fail "Laravel project missing package.json"
        fi
        
        # Clean up
        cd /tmp
        rm -rf test-laravel-project
    else
        print_fail "Failed to create Laravel project"
    fi
else
    print_fail "Laravel installer not available"
fi

echo

# Test 10: Check Claude Code integration
print_test "Checking Claude Code integration..."

if command -v claude &> /dev/null; then
    print_pass "Claude Code CLI is available"
else
    print_fail "Claude Code CLI is not available"
    print_info "Install Claude Code from: https://claude.ai/download"
fi

echo

# Summary
echo "📊 Test Summary"
echo "==============="

# Count pass/fail (simple approximation)
total_tests=$(grep -c "print_pass\|print_fail" "/home/dara/development/ansible-dev-setup/test-setup.sh" 2>/dev/null || echo "unknown")
echo "Total components tested: ~30"
echo
echo "🎯 Next Steps:"
echo "1. Address any FAIL items above"
echo "2. Run the setup script: ./scripts/dev-setup.sh"
echo "3. Restart your terminal or run: source ~/.zshrc"
echo "4. Create your first Laravel project: laravel-new my-project react"
echo "5. Happy coding! 🚀"

echo
echo "💡 Quick Start Commands:"
echo "  laravel-new project-name [react]  # Create new Laravel project"
echo "  dev-start                         # Start development servers"
echo "  nv .                             # Open in Neovim"
echo "  cc                               # Open in Claude Code"
echo "  claude-nvim filename             # Edit with Claude then Neovim"