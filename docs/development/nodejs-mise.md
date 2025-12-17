# 📦 Node.js Version Management with Mise

Complete guide to managing Node.js versions using mise in your development environment.

## 🎯 What is Mise?

Mise (formerly rtx) is a modern, fast version manager written in Rust that:
- ✅ Manages multiple language versions (Node.js, Python, PHP, Ruby, etc.)
- ✅ Automatically switches versions per project
- ✅ Eliminates npm permission errors (no more EACCES)
- ✅ Works consistently across WSL2, Linux, and macOS
- ✅ Blazing fast (written in Rust)

## 🚀 Quick Start

### Check Installation

```bash
# Verify mise is installed and activated
mise doctor

# See what's currently installed
mise list

# Check current Node.js version
node --version
npm --version
```

### Basic Usage

```bash
# See available Node.js versions
mise ls-remote node

# Install specific version
mise use node@20.10.0

# Use latest LTS (recommended)
mise use node@lts

# Use latest version
mise use node@latest
```

## 📂 Project-Specific Versions

### Option 1: Using `.mise.toml` (Recommended)

Create a `.mise.toml` file in your project root:

```toml
[tools]
node = "20.10.0"
# You can also use:
# node = "lts"
# node = "latest"
```

When you `cd` into the project, mise automatically switches to that version!

```bash
# Create project-specific version
cd ~/development/my-project
mise use node@20

# Verify it created .mise.toml
cat .mise.toml
```

### Option 2: Using `.node-version` (NVM Compatible)

For compatibility with NVM and other tools:

```bash
# Create .node-version file
echo "20.10.0" > .node-version

# mise will automatically detect and use it
cd ~/development/my-project
node --version
```

### Option 3: Using `.nvmrc` (NVM Compatible)

Mise also supports `.nvmrc` files:

```bash
# Create .nvmrc file
echo "lts" > .nvmrc

# mise automatically uses it
cd ~/development/my-project
node --version
```

## 🌍 Global vs Project Versions

```bash
# Set global default Node version
mise use -g node@lts

# Set project-specific version (creates .mise.toml)
cd ~/development/my-project
mise use node@18

# Check what version is active
mise current
```

The global version (`~/.config/mise/config.toml`) is used when no project-specific version is found.

## 📦 NPM Global Packages

One of the best features of mise: **no more permission errors**!

```bash
# Install global packages (no sudo needed!)
npm install -g @playwright/test
npm install -g prettier
npm install -g typescript

# List global packages
npm list -g --depth=0

# Update global packages
npm update -g

# Uninstall global package
npm uninstall -g package-name
```

All global packages are stored in `~/.local/share/mise/installs/node/<version>/`, so you never need sudo.

## 🔄 Upgrading Node.js

```bash
# Update to latest LTS
mise use -g node@lts
mise install

# Update project to specific version
cd ~/development/my-project
mise use node@22
mise install

# Verify
node --version
```

## 🛠️ Common Workflows

### Laravel + Vite Development

```bash
# In your Laravel project
cd ~/development/my-laravel-app

# Set Node version for this project
mise use node@lts

# Install dependencies
npm install

# Start development server
npm run dev
```

### React Development

```bash
# Create new React project with specific Node version
cd ~/development
mise use node@20
npx create-react-app my-app

# Project will use Node 20
cd my-app
node --version  # v20.x.x
```

### Multiple Projects with Different Versions

```bash
# Project A uses Node 18
cd ~/development/old-project
mise use node@18
npm install

# Project B uses Node 20
cd ~/development/new-project
mise use node@20
npm install

# mise automatically switches when you cd between projects!
```

## 🔍 Troubleshooting

### Check Activation Status

```bash
mise doctor
```

Look for:
- `activated: yes` ✅
- `No problems found` ✅

### Node Not Found or Wrong Version

```bash
# Reload shell configuration
source ~/.zshrc

# Verify mise is in PATH
which mise

# Check if node is managed by mise
which node  # Should show ~/.local/share/mise/installs/node/...
```

### Global Package Not Found

After installing a global package, mise needs to "reshim" (it does this automatically, but you can force it):

```bash
npm install -g some-package
mise reshim  # Usually automatic

# Or restart your shell
source ~/.zshrc
```

### Multiple Node Installations Conflict

```bash
# Check for conflicting Node installations
which -a node

# Should only show mise-managed node
# If you see /usr/bin/node or /snap/bin/node, those are old installations
```

If you have old Node installations (snap, apt, etc.), they may conflict. The Ansible playbook removes snap Node.js, but if you have others:

```bash
# Check what's installed
dpkg -l | grep nodejs
snap list | grep node

# Remove old installations (be careful!)
sudo snap remove node
sudo apt remove nodejs npm
```

## 📚 Advanced Features

### Install Multiple Versions

```bash
# Install several versions
mise install node@18
mise install node@20
mise install node@22

# List all installed versions
mise list

# Switch between them easily
mise use node@18
node --version  # v18.x.x

mise use node@20
node --version  # v20.x.x
```

### Environment Variables

You can set environment variables per project in `.mise.toml`:

```toml
[tools]
node = "lts"

[env]
NODE_ENV = "development"
API_URL = "http://localhost:3000"
```

### Task Running

Mise can also run tasks (like make or npm scripts):

```toml
[tools]
node = "lts"

[tasks.dev]
run = "npm run dev"

[tasks.build]
run = "npm run build"

[tasks.test]
run = "npm test"
```

Then run:

```bash
mise run dev    # Runs npm run dev
mise run build  # Runs npm run build
mise run test   # Runs npm test
```

## 🔗 Integration with Other Tools

### VS Code / Cursor

Add to your project's `.vscode/settings.json`:

```json
{
  "typescript.tsdk": "node_modules/typescript/lib"
}
```

Mise's Node.js will be automatically used by the integrated terminal.

### GitHub Actions

```yaml
name: CI

on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Install mise
        run: curl https://mise.run | sh

      - name: Install Node.js via mise
        run: |
          echo 'eval "$(~/.local/bin/mise activate bash)"' >> $BASH_ENV
          mise install

      - name: Install dependencies
        run: npm install

      - name: Run tests
        run: npm test
```

### Docker

In your Dockerfile:

```dockerfile
FROM ubuntu:22.04

# Install mise
RUN curl https://mise.run | sh

# Copy project files
COPY . /app
WORKDIR /app

# Install Node.js version from .mise.toml
RUN eval "$(~/.local/bin/mise activate bash)" && mise install

# Install dependencies
RUN eval "$(~/.local/bin/mise activate bash)" && npm install
```

## 📖 Quick Reference

### Most Used Commands

```bash
# Install/update versions from config file
mise install

# Use specific Node version
mise use node@lts

# Set global default
mise use -g node@lts

# List installed versions
mise list

# See available versions
mise ls-remote node

# Current active versions
mise current

# Health check
mise doctor

# Update mise itself
mise self-update

# Remove a version
mise uninstall node@18
```

### Configuration Files

| File | Purpose | Scope |
|------|---------|-------|
| `~/.config/mise/config.toml` | Global defaults | User-wide |
| `.mise.toml` | Project config | Project |
| `.tool-versions` | ASDF compatible | Project |
| `.node-version` | Simple version file | Project |
| `.nvmrc` | NVM compatible | Project |

## 🆘 Getting Help

```bash
# General help
mise help

# Command-specific help
mise help use
mise help install

# Check version
mise --version
```

## 🔗 Useful Links

- [Mise Official Docs](https://mise.jdx.dev)
- [Mise GitHub](https://github.com/jdx/mise)
- [Node.js Release Schedule](https://nodejs.org/en/about/releases/)

---

**Manage Node.js versions effortlessly with mise!** 📦✨
