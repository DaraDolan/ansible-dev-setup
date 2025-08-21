# ⌨️  Neovim Keybindings Reference

Master your Neovim workflow with these carefully crafted keybindings for PHP/Laravel/React development.

## 🎯 Leader Key
**Leader key is `<Space>`** - all custom shortcuts start with space.

## 🔍 File Navigation & Search

| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>f` | Git Files | Find files tracked by Git |
| `<leader>F` | All Files | Find all files in project |
| `<leader>b` | Buffers | Switch between open files |
| `<leader>/` | Live Grep | Search text across project |
| `<leader>h` | Old Files | Recently opened files |
| `<leader>H` | Command History | Previous commands |
| `<leader><leader>d` | Dotfiles | Quick access to config |

## 📝 Editing & Text Manipulation

| Shortcut | Action | Description |
|----------|--------|-------------|
| `jj` | Escape | Exit insert mode |
| `<leader>w` | Save | Write current file |
| `jw` | Save | Save from insert mode |
| `;;` | Append `;` | Add semicolon at end of line |
| `,,` | Append `,` | Add comma at end of line |
| `H` | Line Start | Go to beginning of line |
| `L` | Line End | Go to end of line |
| `Y` | Yank Line | Copy to end of line |

### Text Movement
| Shortcut | Action | Description |
|----------|--------|-------------|
| `J` | Move Down | Move selected text down (visual) |
| `K` | Move Up | Move selected text up (visual) |
| `<leader>j` | Line Down | Move current line down |
| `<leader>k` | Line Up | Move current line up |
| `<C-j>` | Line Down | Move line down (insert mode) |
| `<C-k>` | Line Up | Move line up (insert mode) |

### Text Wrapping
| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>"` | Quote Word | Wrap word in double quotes |
| `<leader>'` | Quote Word | Wrap word in single quotes |
| `<leader>'` | Quote Selection | Wrap selection (visual) |

## 🧠 Language Server (LSP)

| Shortcut | Action | Description |
|----------|--------|-------------|
| `gd` | Definition | Go to definition |
| `gD` | Declaration | Go to declaration |
| `gr` | References | Find all references |
| `gi` | Implementation | Go to implementation |
| `K` | Hover | Show documentation |
| `<C-k>` | Signature | Function signature help |
| `<leader>ca` | Code Actions | Available code actions |
| `<leader>rn` | Rename | Rename symbol |
| `<leader>d` | Diagnostics | Show error details |
| `[d` | Previous Error | Go to previous diagnostic |
| `]d` | Next Error | Go to next diagnostic |
| `<leader>p` | Format | Format current file |

## 🧪 Testing (Pest)

| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>tn` | Test Nearest | Run test under cursor |
| `<leader>tf` | Test File | Run current test file |
| `<leader>ts` | Test Suite | Run entire test suite |
| `<leader>tl` | Test Last | Re-run last test |
| `<leader>tv` | Test Visit | Visit last test file |

## 🎯 Laravel Specific

| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>la` | Artisan | Laravel artisan commands |
| `<leader>lr` | Routes | Browse Laravel routes |
| `<leader>lm` | Related | Find related Laravel files |
| `<leader>lc` | Controller | Make new controller |
| `<leader>lmi` | Migration | Make new migration |
| `<leader>ls` | Serve | Start Laravel server |
| `<leader>lt` | Test | Run Laravel tests |

## ⚛️  Frontend Development

| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>nd` | Dev Server | Start npm dev server |
| `<leader>nb` | Build | Build for production |
| `<leader>ni` | Install | Install npm dependencies |
| `<leader>tw` | Tailwind Init | Initialize Tailwind CSS |

## 🤖 Claude Code Integration

| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>cc` | Claude Project | Open project in Claude Code |
| `<leader>ce` | Claude Edit | Edit current file with Claude |

## 🌲 File Explorer

| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>e` | Toggle Tree | Open/close file explorer |

### In File Explorer
| Key | Action |
|-----|--------|
| `<space>` | Toggle folder |
| `<cr>` | Open file |
| `s` | Split vertical |
| `S` | Split horizontal |
| `a` | Add file |
| `A` | Add directory |
| `r` | Rename |
| `d` | Delete |
| `q` | Close explorer |

## 🔀 Git Integration

| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>G` | Git Status | Fugitive git status |
| `<leader>hs` | Stage Hunk | Stage git hunk |
| `<leader>hr` | Reset Hunk | Reset git hunk |
| `<leader>hp` | Preview Hunk | Preview changes |
| `<leader>hb` | Blame Line | Git blame |
| `<leader>tb` | Toggle Blame | Toggle line blame |
| `]c` | Next Hunk | Next git change |
| `[c` | Previous Hunk | Previous git change |

## 📋 Buffer Management

| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>bn` | Next Buffer | Switch to next buffer |
| `<leader>bp` | Previous Buffer | Switch to previous buffer |
| `<leader>bd` | Delete Buffer | Close current buffer |

## 🪟 Window/Split Navigation

| Shortcut | Action | Description |
|----------|--------|-------------|
| `<C-h>` | Left Split | Move to left window |
| `<C-j>` | Down Split | Move to bottom window |
| `<C-k>` | Up Split | Move to top window |
| `<C-l>` | Right Split | Move to right window |

## 🔧 Configuration

| Shortcut | Action | Description |
|----------|--------|-------------|
| `<leader>ve` | Edit Config | Edit Neovim configuration |

## 📐 Advanced Navigation

| Shortcut | Action | Description |
|----------|--------|-------------|
| `n` | Next Search | Next search (centered) |
| `N` | Previous Search | Previous search (centered) |
| `J` | Join Lines | Join lines (centered) |

### Smart Jump Tracking
- Large movements (`5j` or `5k`) automatically add jump points
- Use `<C-o>` and `<C-i>` to navigate jump list

## 🎨 Snippets

Type these prefixes and press Tab for instant templates:

### PHP/Laravel
- `php` - PHP opening tag
- `class` - PHP class
- `method` - Class method
- `controller` - Laravel controller
- `model` - Laravel model
- `migration` - Laravel migration
- `route` - Laravel route

### Pest Testing
- `pest` - Basic Pest test
- `pestfeature` - Feature test
- `pestunit` - Unit test
- `expect` - Expectation
- `dataset` - Test with datasets
- `mock` - Mock object

### React/TypeScript
- `rfc` - React functional component
- `useState` - useState hook
- `useEffect` - useEffect hook
- `context` - React context

### Tailwind CSS
- `btn` - Button component
- `card` - Card component
- `grid` - Responsive grid
- `flex-center` - Centered flex

## 🆘 Help & Learning

| Command | Purpose |
|---------|----------|
| `:help <topic>` | Get help on any topic |
| `:checkhealth` | Verify Neovim setup |
| `:WhichKey` | Show all available shortcuts |
| `:Telescope commands` | Browse all commands |

## 💡 Pro Tips

1. **Muscle Memory**: Practice common shortcuts daily
2. **Telescope**: Use `<leader>F` then `<C-p>` for recent files
3. **LSP Navigation**: `gd` → `<C-o>` to jump back
4. **Testing Flow**: `<leader>tf` while editing tests
5. **Git Workflow**: Stage hunks with `<leader>hs`
6. **Claude Integration**: Complex refactoring with `<leader>cc`

---

**Master these shortcuts for lightning-fast Laravel/React development!** ⚡