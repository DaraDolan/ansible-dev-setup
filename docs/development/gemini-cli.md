# 🤖 Google Gemini CLI Guide

Complete guide to using the Google Gemini CLI for AI-assisted development.

## 🎯 What is Gemini CLI?

The Google Gemini CLI is a command-line interface for Google's Gemini AI models, allowing you to:
- 💬 Chat with AI directly from your terminal
- 🔨 Generate code snippets and boilerplate
- 🔍 Analyze and review code files
- 📝 Get instant answers to development questions
- 🚀 Integrate AI into your development workflow

## 🚀 Installation

The Gemini CLI is automatically installed via the Ansible playbook as a global npm package.

### Verify Installation

```bash
# Check if gemini is installed
gemini --version

# Get help
gemini --help
```

## 🔑 Setup & Configuration

### Get Your API Key

1. Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Create a new API key
3. Copy the key

### Configure the CLI

```bash
# Set your API key (required)
gemini config set apiKey YOUR_API_KEY_HERE

# Set default model (optional)
gemini config set model gemini-pro

# View current configuration
gemini config list
```

### Environment Variable Alternative

You can also set the API key via environment variable:

```bash
# Add to ~/.zshrc or ~/.bashrc
export GEMINI_API_KEY="your-api-key-here"

# Or set for current session only
export GEMINI_API_KEY="your-api-key-here"
gemini chat "Hello"
```

## 💬 Chat Mode

### Basic Chat

```bash
# Ask a question
gemini chat "How do I create a Laravel middleware?"

# Multi-line input
gemini chat "Explain the following concepts:
1. Laravel Service Container
2. Dependency Injection
3. Service Providers"
```

### Chat with Code Files

```bash
# Analyze a specific file
gemini chat -f app/Models/User.php "Review this model for best practices"

# Multiple files
gemini chat -f app/Http/Controllers/UserController.php -f app/Models/User.php "Explain how these files work together"

# Analyze and suggest improvements
gemini chat -f routes/web.php "Are there any security concerns in these routes?"
```

### Interactive Chat Session

```bash
# Start an interactive chat (coming soon in newer versions)
gemini chat --interactive
```

## 🔨 Code Generation

### Generate Code

```bash
# Generate a Laravel controller
gemini generate "Create a Laravel controller for managing blog posts with CRUD operations"

# Generate a migration
gemini generate "Create a Laravel migration for a products table with name, price, description, and timestamps"

# Generate React component
gemini generate "Create a React functional component for a user profile card with TypeScript"

# Generate tests
gemini generate "Create Pest tests for a Laravel UserController with tests for index, show, store, update, and destroy methods"
```

### Save Generated Code

```bash
# Generate and save to file
gemini generate "Create a Laravel API controller for posts" > app/Http/Controllers/Api/PostController.php

# Review before saving
gemini generate "Create a user repository class" | less
```

## 🎨 Development Workflows

### Laravel Development

```bash
# Explain Laravel concepts
gemini chat "Explain Laravel Eloquent relationships with examples"

# Review your code
gemini chat -f app/Http/Controllers/PostController.php "Are there any N+1 query issues?"

# Generate boilerplate
gemini generate "Create a Laravel Form Request for validating blog post creation"

# Debugging help
gemini chat "I'm getting 'Class not found' error in Laravel. What could be the causes?"
```

### React/Frontend Development

```bash
# Component generation
gemini generate "Create a React hook for fetching data with loading and error states"

# Review components
gemini chat -f components/PostCard.jsx "How can I improve this component's performance?"

# Styling help
gemini chat "Give me Tailwind CSS classes for a modern card with hover effect"
```

### Python Development

```bash
# Generate Python code
gemini generate "Create a FastAPI endpoint for user authentication with JWT"

# Review Python files
gemini chat -f main.py "Check this code for potential bugs"

# Data science help
gemini chat "How do I use pandas to merge two dataframes on multiple columns?"
```

### Debugging & Problem Solving

```bash
# Error analysis
gemini chat "I'm getting this error: 'SQLSTATE[23000]: Integrity constraint violation'. What does it mean and how do I fix it?"

# Code review
gemini chat -f app/Services/PaymentService.php "Review this code for security vulnerabilities"

# Performance optimization
gemini chat "How can I optimize this Laravel query: User::with('posts')->get()"

# Best practices
gemini chat "What are the best practices for organizing Laravel controllers?"
```

## 🎯 Advanced Usage

### Working with Multiple Files

```bash
# Analyze entire feature
gemini chat \
  -f app/Models/Post.php \
  -f app/Http/Controllers/PostController.php \
  -f app/Http/Requests/StorePostRequest.php \
  "Explain how these files work together to handle blog post creation"
```

### Piping and Chaining

```bash
# Get code and review it
gemini generate "Laravel validation rules for user registration" | \
  gemini chat "Are these validation rules secure?"

# Generate and format
gemini generate "PHP function to calculate fibonacci" | php -l
```

### Using Different Models

```bash
# List available models
gemini models

# Use a specific model
gemini chat --model gemini-pro "Explain Docker compose"

# Use Gemini Pro Vision (for images, if supported)
gemini chat --model gemini-pro-vision -f screenshot.png "What's in this image?"
```

## 🔧 Configuration Options

### View All Settings

```bash
# Show current configuration
gemini config list

# Show specific setting
gemini config get model
```

### Available Settings

```bash
# API Key
gemini config set apiKey YOUR_KEY

# Default model
gemini config set model gemini-pro

# Temperature (creativity level, 0.0-1.0)
gemini config set temperature 0.7

# Max tokens (response length)
gemini config set maxTokens 2048
```

## 💡 Tips & Best Practices

### Writing Effective Prompts

**Be Specific:**
```bash
# ❌ Too vague
gemini chat "Make a controller"

# ✅ Clear and specific
gemini chat "Create a Laravel API controller for user management with methods for listing users, creating a new user, updating user details, and soft deleting users"
```

**Provide Context:**
```bash
# ❌ No context
gemini chat -f User.php "Fix this"

# ✅ With context
gemini chat -f app/Models/User.php "This User model is throwing a 'Call to undefined method' error when I try to use the fullName attribute. Can you identify the issue?"
```

**Use Examples:**
```bash
gemini chat "Create a Laravel validation rule that ensures email is unique in the users table, similar to how we validate username uniqueness"
```

### Security Considerations

⚠️ **Important Security Notes:**

1. **Never share API keys in code or commits**
   ```bash
   # Add to .gitignore
   echo ".gemini-config" >> .gitignore
   ```

2. **Don't send sensitive data to AI**
   - Avoid sending production database credentials
   - Don't include API keys or secrets in files you analyze
   - Be cautious with proprietary business logic

3. **Review generated code**
   - Always review AI-generated code before using it
   - Test thoroughly, especially security-critical code
   - Verify that generated code follows your project's standards

## 🎨 Integrating with Your Workflow

### Alias Shortcuts

Add these to your `~/.zshrc`:

```bash
# Quick chat
alias gm='gemini chat'

# Review current file
alias gmr='gemini chat -f'

# Generate code
alias gmg='gemini generate'

# Quick Laravel help
alias gml='gemini chat "Laravel:"'
```

Usage:
```bash
gm "How do I use Redis in Laravel?"
gmr app/Models/Post.php "Review this model"
gmg "Create a migration for products table"
```

### Neovim Integration

You can call Gemini from within Neovim:

```lua
-- Add to your Neovim config
vim.keymap.set('n', '<leader>ai', function()
  local file = vim.fn.expand('%')
  local question = vim.fn.input('Ask Gemini: ')
  vim.cmd('split | term gemini chat -f ' .. file .. ' "' .. question .. '"')
end, { desc = 'Ask Gemini about current file' })
```

### Git Commit Messages

```bash
# Generate commit message from changes
git diff | gemini chat "Write a concise git commit message for these changes"

# Review changes before committing
git diff | gemini chat "Review these changes for potential issues"
```

## 🆘 Troubleshooting

### API Key Issues

```bash
# Check if API key is set
gemini config get apiKey

# Reset configuration
rm ~/.gemini-config
gemini config set apiKey YOUR_KEY
```

### Command Not Found

```bash
# Check if globally installed
npm list -g @google/gemini-cli

# Reinstall if needed
npm install -g @google/gemini-cli

# Verify mise is active
mise doctor
```

### Rate Limiting

If you hit rate limits:
- Wait a few minutes between requests
- Consider upgrading your API quota
- Use more specific prompts to reduce token usage

## 📚 Examples Library

### Laravel Examples

```bash
# Generate full CRUD controller
gemini generate "Laravel resource controller for Product model with repository pattern"

# Create middleware
gemini generate "Laravel middleware to check if user has admin role"

# Generate API resources
gemini generate "Laravel API resource for transforming User model with nested posts relationship"

# Create form request
gemini generate "Laravel form request for validating product creation with rules for name (required, max 255), price (required, numeric, min 0), and description (optional)"
```

### Testing Examples

```bash
# Generate Pest tests
gemini generate "Pest feature tests for UserController with tests for authentication, authorization, and CRUD operations"

# Test data factories
gemini generate "Laravel factory for Product model with realistic fake data"

# Generate test dataset
gemini generate "Pest dataset for testing different user roles: guest, user, admin, super_admin"
```

### React Examples

```bash
# Generate component with TypeScript
gemini generate "React TypeScript component for a data table with sorting, filtering, and pagination"

# Generate custom hook
gemini generate "React custom hook for form validation with TypeScript"

# Generate context provider
gemini generate "React context provider for managing authentication state with TypeScript"
```

## 🔗 Useful Links

- [Google AI Studio](https://makersuite.google.com/app/apikey) - Get API keys
- [Gemini API Documentation](https://ai.google.dev/docs)
- [Gemini CLI GitHub](https://github.com/google/generative-ai-js/tree/main/packages/gemini-cli)

---

**Enhance your development workflow with AI assistance!** 🤖✨
