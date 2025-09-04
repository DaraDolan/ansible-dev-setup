# Neovim Python Integration Guide

Complete guide to using Neovim for Python development with your Ansible-configured environment.

## Table of Contents
- [LSP Features](#lsp-features)
- [Key Bindings](#key-bindings)
- [Code Snippets](#code-snippets)
- [Plugin Integration](#plugin-integration)
- [Debugging](#debugging)
- [Advanced Workflows](#advanced-workflows)
- [Customization](#customization)

## LSP Features

Your Neovim setup includes full Python Language Server Protocol (LSP) support via `pylsp`.

### What You Get
- **Real-time error checking** - Syntax and semantic errors as you type
- **Intelligent autocompletion** - Context-aware code completion
- **Go to definition** - Jump to function/class/variable definitions
- **Find references** - Find all usages of symbols across your project
- **Hover documentation** - View docstrings and type information
- **Code actions** - Quick fixes, imports, and refactoring suggestions
- **Symbol outline** - Navigate project structure
- **Rename refactoring** - Safely rename variables/functions project-wide

### LSP Configuration
The LSP is configured in `/roles/neovim/files/lua/plugins/init.lua` with these settings:

```lua
lspconfig.pylsp.setup({
  capabilities = capabilities,
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = {'W391'},        -- Ignore blank line at end of file
          maxLineLength = 100       -- Set line length to 100 characters
        }
      }
    }
  }
})
```

## Key Bindings

### LSP Navigation
| Key Binding | Action | Description |
|-------------|--------|-------------|
| `gd` | Go to definition | Jump to where symbol is defined |
| `gr` | Go to references | Show all references to symbol |
| `gD` | Go to declaration | Jump to declaration (if different from definition) |
| `gi` | Go to implementation | Jump to implementation |
| `gt` | Go to type definition | Jump to type definition |

### LSP Actions
| Key Binding | Action | Description |
|-------------|--------|-------------|
| `K` | Hover documentation | Show documentation for symbol under cursor |
| `<leader>ca` | Code actions | Show available code actions (fixes, imports, etc.) |
| `<leader>rn` | Rename symbol | Rename symbol across entire project |
| `<Ctrl-Space>` | Trigger completion | Manually trigger autocompletion |
| `[d` | Previous diagnostic | Jump to previous error/warning |
| `]d` | Next diagnostic | Jump to next error/warning |

### File Navigation
| Key Binding | Action | Description |
|-------------|--------|-------------|
| `<leader>ff` | Find files | Search for files in project |
| `<leader>fg` | Live grep | Search for text in files |
| `<leader>fb` | Find buffers | Switch between open files |
| `<leader><leader>d` | Search dotfiles | Quick access to config files |

### Code Actions Examples
When you press `<leader>ca` on Python code, you might see:
- **Add import** - Automatically add missing imports
- **Remove unused import** - Clean up unused imports
- **Fix formatting** - Apply formatting fixes
- **Extract variable** - Extract expression to variable
- **Extract function** - Extract code block to function

## Code Snippets

Type these prefixes and press `Tab` to expand:

### Basic Python Structures
```python
# Type: def + Tab
def function_name(args):
    """Description"""
    pass

# Type: class + Tab  
class ClassName:
    """Description"""
    
    def __init__(self, args):
        pass

# Type: main + Tab
if __name__ == "__main__":
    pass
```

### Control Flow
```python
# Type: try + Tab
try:
    pass
except Exception as e:
    pass

# Type: for + Tab
for item in iterable:
    pass

# Type: while + Tab
while condition:
    pass
```

### Web Development
```python
# Type: fastapi + Tab
@app.get("/endpoint")
async def function_name(params):
    """Description"""
    pass

# Type: flask + Tab
@app.route("/endpoint", methods=["GET"])
def function_name():
    """Description"""
    pass
```

### Testing
```python
# Type: test + Tab
def test_function_name():
    """Test description"""
    # Arrange
    pass
    
    # Act
    pass
    
    # Assert
    assert True
```

### Data Structures
```python
# Type: lc + Tab (List Comprehension)
[expr for item in iterable]

# Type: dc + Tab (Dict Comprehension)  
{key: value for item in iterable}
```

### Debugging
```python
# Type: pdb + Tab
print(f"variable: {variable}")
```

### Documentation
```python
# Type: doc + Tab
"""
Description

Args:
    param: Description

Returns:
    Description
"""
```

## Plugin Integration

### Autocompletion (nvim-cmp)
Your setup includes intelligent autocompletion that works with:

- **LSP suggestions** - From Python language server
- **Buffer content** - From open files
- **File paths** - For imports and file references
- **Snippets** - Custom Python snippets

#### Completion Navigation
- `Tab` - Accept suggestion or move to next item
- `Shift+Tab` - Move to previous item
- `Ctrl+Space` - Trigger completion manually
- `Ctrl+e` - Dismiss completion
- `Enter` - Confirm selection

### Treesitter Syntax Highlighting
Enhanced syntax highlighting for Python including:
- Function definitions and calls
- Class structures
- Decorators
- String formatting
- Type hints
- Docstrings

### File Explorer (Neo-tree)
Navigate Python projects efficiently:
- `<leader>e` - Toggle file explorer
- Show Python file structure
- Git status integration
- File type icons

### Telescope (Fuzzy Finder)
Powerful search across Python projects:
- `<leader>ff` - Find Python files
- `<leader>fg` - Search in Python file contents
- `<leader>fs` - Search symbols (functions, classes)

## Debugging

### Built-in Python Debugging
```python
# Add breakpoint
import pdb; pdb.set_trace()

# Modern breakpoint (Python 3.7+)
breakpoint()
```

### Debug with Print Statements
Use the `pdb` snippet for quick debug prints:
```python
# Type: pdb + Tab
print(f"variable_name: {variable_name}")
```

### LSP Diagnostics
View errors and warnings:
- **Error signs** - Red signs in gutter for errors
- **Warning signs** - Yellow signs for warnings
- **Inline diagnostics** - Error messages inline with code
- **Diagnostic list** - `:lua vim.diagnostic.setloclist()` for error list

### Debugging Commands in Neovim
```vim
" Show diagnostic information
:lua vim.diagnostic.open_float()

" Jump to next/previous diagnostic
]d  " Next diagnostic
[d  " Previous diagnostic

" Show all diagnostics in quickfix list
:lua vim.diagnostic.setqflist()
```

## Advanced Workflows

### 1. Import Management
The LSP automatically helps with imports:

```python
# Type a function name that's not imported
requests.get("https://api.github.com")
# ^^ This will be underlined as error

# Press <leader>ca to see code actions:
# - "Import requests" (automatically adds: import requests)
```

### 2. Refactoring
```python
# Rename variable/function across entire project
# 1. Place cursor on symbol
# 2. Press <leader>rn
# 3. Type new name
# 4. Press Enter
# All references updated automatically!
```

### 3. Quick Documentation
```python
# Place cursor on any function/class and press K
print()  # <- cursor here, press K
# Shows: print(*values, sep=' ', end='\\n', file=sys.stdout, flush=False)
```

### 4. Type Checking Integration
If you have mypy installed:
```bash
# In terminal
uv add --dev mypy
uv run mypy src/

# Or create a custom command in Neovim
:!uv run mypy %
```

### 5. Code Formatting
```vim
" Format current file
:lua vim.lsp.buf.format()

" Format with external tool (if installed)
:!uv run black %
:!uv run ruff format %
```

## Customization

### Adding Custom Snippets
Edit `/roles/neovim/files/snippets/python.json`:

```json
{
  "Custom Function": {
    "prefix": "myfunc",
    "body": [
      "def ${1:function_name}(${2:self}, ${3:args}):",
      "    \"\"\"${4:Custom function description}\"\"\"",
      "    ${5:pass}",
      "$0"
    ],
    "description": "My custom function template"
  }
}
```

### LSP Customization
Modify `/roles/neovim/files/lua/plugins/init.lua`:

```lua
-- Customize pylsp settings
lspconfig.pylsp.setup({
  capabilities = capabilities,
  settings = {
    pylsp = {
      plugins = {
        -- Enable/disable specific plugins
        pycodestyle = { enabled = true, maxLineLength = 120 },
        mccabe = { enabled = true, threshold = 15 },
        pyflakes = { enabled = true },
        pylint = { enabled = false },  -- Disable if you prefer ruff
        
        -- Formatting (choose one)
        black = { enabled = true },
        autopep8 = { enabled = false },
        yapf = { enabled = false },
      }
    }
  }
})
```

### Key Binding Customization
Add to your Neovim config:

```lua
-- Custom Python key bindings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    local opts = { buffer = true }
    
    -- Run current file
    vim.keymap.set('n', '<leader>r', ':!uv run python %<CR>', opts)
    
    -- Run tests
    vim.keymap.set('n', '<leader>t', ':!uv run pytest<CR>', opts)
    
    -- Format with black
    vim.keymap.set('n', '<leader>f', ':!uv run black %<CR>', opts)
    
    -- Lint with ruff
    vim.keymap.set('n', '<leader>l', ':!uv run ruff check %<CR>', opts)
  end,
})
```

### Python-specific Settings
```lua
-- Python indentation and formatting
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
    vim.opt_local.textwidth = 100
    vim.opt_local.colorcolumn = "100"
  end,
})
```

## Quick Reference

### Essential Python + Neovim Workflow
1. **Open project**: `nvim .`
2. **Find files**: `<leader>ff` 
3. **Navigate code**: `gd` (definition), `gr` (references)
4. **Get help**: `K` (documentation)
5. **Fix issues**: `<leader>ca` (code actions)
6. **Rename**: `<leader>rn` (rename symbol)
7. **Format**: `:lua vim.lsp.buf.format()`
8. **Search**: `<leader>fg` (grep in files)

### Common Commands
```bash
# Terminal commands (from project root)
uv run python src/myproject/main.py    # Run main file
uv run pytest                          # Run tests  
uv run black src/                       # Format code
uv run ruff check src/                  # Lint code
uv add requests                         # Add dependency
```

```vim
" Neovim commands
:LspInfo           " Check LSP status
:LspRestart        " Restart language server
:Telescope         " Open Telescope menu
:Mason             " Manage LSP servers
```

This guide should give you everything you need to be highly productive with Python in your Neovim environment!