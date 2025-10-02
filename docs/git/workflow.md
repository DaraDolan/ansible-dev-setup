# Git Workflow in Neovim

This document outlines the Git workflow using the configured Neovim setup with Gitsigns and Fugitive.

## Navigation Between Changed Files

### In Neotree
- `[g` - Previous file with git changes
- `]g` - Next file with git changes

### Using Telescope
- `<leader>m` - Show git status (modified files)
- `<leader>f` - Find git files (tracked files only)

## Navigation Within Files (Hunks)

### Hunk Navigation
- `]c` - Next hunk (changed lines)
- `[c` - Previous hunk (changed lines)

### Hunk Operations
- `<leader>hp` - Preview hunk changes (press `<Esc>` or `q` to close)
- `<leader>hs` - Stage hunk
- `<leader>hr` - Reset hunk
- `<leader>hu` - Undo stage hunk

### Buffer Operations
- `<leader>hS` - Stage entire buffer
- `<leader>hR` - Reset entire buffer

### Git Blame
- `<leader>hb` - Show git blame for current line

## Git Status and Commands

### Fugitive Commands
- `<leader>G` - Open Git status window
- `<leader><leader>go` - Open current file/line in GitHub

### LazyGit Integration
- `<leader>gg` - Open LazyGit in floating terminal

## Visual Git Signs

Git changes are indicated in the sign column with these symbols:
- `│` - Added lines
- `│` - Changed lines
- `_` - Deleted lines
- `‾` - Top deleted lines
- `~` - Changed and deleted lines

## Typical Workflow

1. **See what files changed**: `<leader>m` or use Neotree with `[g`/`]g`
0. **Find old files**: `<leader><leader>f` - Project history/old files
2. **Navigate to changes in file**: Use `]c`/`[c` to jump between hunks
3. **Review changes**: Use `<leader>hp` to preview what changed
4. **Stage changes**: Use `<leader>hs` for individual hunks or `<leader>hS` for entire file
5. **Commit**: Use `<leader>G` for Fugitive or `<leader>gg` for LazyGit

## Tips

- Use `?` in Neotree to see all available mappings
- Git signs appear in the left gutter showing change types
- Preview popups can be closed with `<Esc>` or `q`
- All git operations work with both individual hunks and entire buffers