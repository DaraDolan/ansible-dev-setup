#!/bin/bash

# Development Environment Setup Script
# Convenience wrapper around Ansible playbook with enhanced error handling

set -e

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

# Check for sudo access
check_sudo() {
    if ! sudo -n true 2>/dev/null; then
        print_error "This script requires sudo privileges to install packages."
        echo ""
        echo "Please run one of the following:"
        echo "1. Run with sudo: sudo $0"
        echo "2. Configure passwordless sudo temporarily:"
        echo "   echo '$USER ALL=(ALL) NOPASSWD: /usr/bin/apt, /usr/bin/apt-get, /bin/mv, /bin/chmod, /usr/sbin/chsh' | sudo tee /etc/sudoers.d/dev-setup"
        echo "   $0"
        echo "   sudo rm /etc/sudoers.d/dev-setup"
        echo "3. Use the Ansible approach directly: ansible-playbook -i inventory/hosts.yml playbook.yml -K"
        exit 1
    fi
}

# Check if Ansible is installed
check_ansible() {
    if ! command -v ansible-playbook &> /dev/null; then
        print_status "Ansible not found. Installing..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            if command -v brew &> /dev/null; then
                brew install ansible
            else
                print_error "Please install Homebrew first or install Ansible manually"
                exit 1
            fi
        else
            # Linux
            sudo apt update
            sudo apt install -y ansible
        fi
        print_success "Ansible installed successfully"
    fi
}

# Main setup
echo "🚀 Setting up your PHP/Laravel/React development environment..."

# Check prerequisites
check_sudo
check_ansible

# Run the Ansible playbook
print_status "Running Ansible playbook..."

if ansible-playbook -i inventory/hosts.yml playbook.yml -K; then
    print_success "Development environment setup completed!"
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
else
    print_error "Ansible playbook failed. Please check the output above for errors."
    echo ""
    echo "Alternative approaches:"
    echo "1. Run the playbook manually: ansible-playbook -i inventory/hosts.yml playbook.yml -K -vvv"
    echo "2. Check the troubleshooting guide in README.md"
    exit 1
fi