# Your Mind-Bending Neovim Workflows

## 🎯 Goal
Master your enhanced Neovim setup while building the Portfolio Tracker Pro.

## 🏠 Starting Your Session

### Beautiful Dashboard
When you open Neovim with `nvim .`, you'll see:
```
  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ 
  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ 
  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ 
  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ 
  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ 
  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ 

                 [ Laravel + React Pro ]            
```

**Dashboard Actions:**
- `e` - New file
- `f` - Find files  
- `r` - Recent files
- `s` - Restore session
- `l` - Open Lazy (plugin manager)

## 🎨 Theme Switching

Switch between beautiful colorschemes:
- `<leader>cn` - **Nord** theme (cool blues)
- `<leader>cc` - **Catppuccin** theme (warm pastels)  
- `<leader>ck` - **Kanagawa** theme (Japanese aesthetic)

## ⚡ Lightning-Fast Navigation

### Telescope Fuzzy Finding
- `<leader>f` - Find files (git files)
- `<leader>F` - Find all files  
- `<leader>/` - Live grep (search in files)
- `<leader>b` - Find open buffers
- `<leader>h` - Recent files (history)
- `<leader><leader>d` - Search your dotfiles

### Harpoon - The Game Changer
**Mark your most important files:**
- `<leader>a` - Add current file to Harpoon
- `<C-e>` - Toggle Harpoon quick menu
- `<leader>1` - Jump to file 1
- `<leader>2` - Jump to file 2  
- `<leader>3` - Jump to file 3
- `<leader>4` - Jump to file 4

**Typical Harpoon Setup for Laravel:**
1. `routes/web.php` 
2. `app/Models/User.php`
3. `resources/js/app.tsx`
4. `database/migrations/latest_migration.php`

### File Managers
- `<leader>e` - **Neo-tree** (sidebar file explorer)
- `<leader>o` - **Oil.nvim** (edit directories like files)
- `-` - Go to parent directory in Oil

## 💻 Terminal Integration

### ToggleTerm - Multiple Terminals
- `<C-\>` - Toggle floating terminal
- `<leader>th` - Horizontal terminal
- `<leader>tv` - Vertical terminal  
- `<leader>tt` - Terminal in new tab

**In terminal mode:**
- `<Esc>` or `jk` - Exit to normal mode
- `<C-h/j/k/l>` - Navigate between windows

### Git Integration
- `<leader>gg` - **LazyGit** (beautiful Git TUI)
- `<leader>gd` - **DiffView** (compare branches/commits)
- `<leader>G` - Git status (fugitive)

**Gitsigns (in files):**
- `]c` - Next git change
- `[c` - Previous git change  
- `<leader>hs` - Stage hunk
- `<leader>hr` - Reset hunk
- `<leader>hp` - Preview hunk

## 🤖 AI-Powered Development

### GitHub Copilot
- `<C-g>` - Accept Copilot suggestion
- Start typing - Copilot suggests completions
- Perfect for boilerplate code and patterns

### Advanced Code Intelligence
- `gd` - Go to definition
- `gr` - Find references
- `gi` - Go to implementation  
- `K` - Show documentation
- `<leader>ca` - Code actions
- `<leader>rn` - Rename symbol
- `<leader>d` - Show diagnostics

## 📝 Snippet Mastery

### Laravel Snippets
Type these and press `Tab`:

**Controllers:**
```php
controller<Tab>
```
Expands to full Laravel controller template.

**Models:**  
```php
model<Tab>
```
Creates complete Eloquent model structure.

**Migrations:**
```php
migration<Tab>  
```
Full migration with up/down methods.

**Routes:**
```php
route<Tab>
```
Laravel route definition.

### React/TypeScript Snippets

**Components:**
```typescript
rfc<Tab>  // React Functional Component
```

**Hooks:**
```typescript  
useState<Tab>   // useState with TypeScript
useEffect<Tab>  // useEffect hook
```

**UI Components:**
```typescript
btn<Tab>    // Button with Tailwind variants
card<Tab>   // Card component  
modal<Tab>  // Modal with backdrop
```

## 🔍 Search & Replace

### Project-wide Search/Replace
- `<leader>sr` - **Spectre** (advanced search/replace)
- `<leader>sw` - Replace word under cursor
- Select text, then `<leader>sw` - Replace selection

### Buffer Search
- `<leader>l` - Fuzzy find lines in current buffer
- `/pattern` - Search in buffer
- `n` / `N` - Next/previous match (stays centered)

## 🔧 Diagnostics & Debugging

### Trouble - Error Management
- `<leader>xx` - Toggle diagnostics panel
- `<leader>xX` - Buffer diagnostics only
- `<leader>cs` - Document symbols
- `[d` - Previous diagnostic
- `]d` - Next diagnostic

### LSP Features
- `:LspRestart` - Restart language server
- `:Mason` - Manage language servers
- `<leader>p` - Format file

## 🧘 Focus & Productivity  

### Zen Mode
- `<leader>z` - Toggle Zen Mode (distraction-free)

### Session Management
- `<leader>ss` - Search sessions
- Sessions auto-save when you exit

### Which-key
- Press `<leader>` and wait - see all available shortcuts
- Learn keybindings as you go!

## 📊 Advanced Features

### Code Folding
- `zc` - Close fold
- `zo` - Open fold  
- `zR` - Open all folds
- `zM` - Close all folds

Beautiful fold display shows line counts and context.

### Window Management
- `<leader>wh` - Horizontal split
- `<leader>wv` - Vertical split  
- `<leader>we` - Equalize windows
- `<leader>wx` - Close window
- `<C-h/j/k/l>` - Navigate windows

### Buffer Management
- `<leader>bn` - Next buffer
- `<leader>bp` - Previous buffer
- `<leader>bd` - Delete buffer
- `<leader>ba` - Close all buffers
- `<leader>bo` - Close all except current

## 🎮 Laravel-Specific Workflows

### Quick File Access
- `<leader>le` - Open `.env` file
- `<leader>lr` - Open `routes/web.php`
- `<leader>la` - Open `routes/api.php`
- `<leader>lc` - Open `config/app.php`

### Laravel Commands (from Neovim)
- `<leader>ls` - Start Laravel server
- `<leader>lt` - Run tests
- `<leader>lm` - Make model (prompts for name)

### Laravel Plugin Features
- `:Laravel artisan` - Run artisan commands
- `:Laravel routes` - View routes
- `:Laravel related` - Find related files

## 🚀 Pro Tips

### Daily Workflow
1. **Start:** `nvim .` (see dashboard)  
2. **Navigate:** Use Harpoon for main files
3. **Search:** `<leader>/` for finding code
4. **Code:** Use snippets and Copilot
5. **Git:** `<leader>gg` for commits
6. **Focus:** `<leader>z` for deep work

### Keyboard Efficiency
- Use `jj` instead of Escape
- `H` / `L` for line start/end
- `;;` adds semicolon at end of line
- `,,` adds comma at end of line

### Visual Mode Tricks
- `J` / `K` - Move selected lines up/down  
- `<leader>'` - Surround selection with quotes

### Learning Mode
- Use `<leader>` and wait - discover new shortcuts
- Try different colorschemes daily
- Experiment with different file managers (Neo-tree vs Oil)

## 🎯 Challenge Yourself

As you build the portfolio tracker, try to use:
- [ ] All 3 colorschemes
- [ ] Harpoon for 4 main files  
- [ ] At least 10 different snippets
- [ ] LazyGit for all commits
- [ ] Zen mode for focused coding
- [ ] Session management
- [ ] Spectre for refactoring
- [ ] Trouble for debugging

## 🔥 Advanced Neovim Ninja

Once comfortable, explore:
- Custom snippets in `~/.config/nvim/snippets/`
- Telescope extensions
- Custom keybindings
- Plugin configuration tweaks
- LSP customization

Your Neovim setup is now a productivity powerhouse! 🚀

Master these workflows, and you'll be coding at the speed of thought! ⚡