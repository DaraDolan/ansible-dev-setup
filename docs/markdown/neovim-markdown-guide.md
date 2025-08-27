# Neovim Markdown Mastery Guide

A comprehensive guide to getting the most out of your markdown editing experience in Neovim.

## Table of Contents

- [Getting Started](#getting-started)
- [Available Snippets](#available-snippets)
- [Key Bindings](#key-bindings)
- [Live Preview](#live-preview)
- [Workflow Examples](#workflow-examples)
- [Advanced Tips](#advanced-tips)
- [Export Options](#export-options)

## Getting Started

Your Neovim setup includes powerful markdown support through:

- **Treesitter** - Syntax highlighting and parsing
- **markdown-preview.nvim** - Live browser preview
- **Custom snippets** - Quick text insertion
- **LSP support** - Language server features
- **Auto-commands** - Markdown-specific settings

### Opening Markdown Files

```bash
# Open a markdown file
nvim document.md

# Start with live preview ready
nvim document.md
# Then press <leader>mp (see Live Preview section)
```

## Available Snippets

Your setup includes these powerful snippets (type the prefix and press Tab):

### Text Formatting

| Snippet       | Trigger         | Result     |
| ------------- | --------------- | ---------- |
| Bold          | `bold` or `b`   | `**text**` |
| Italic        | `italic` or `i` | `*text*`   |
| Strikethrough | `vstrike`       | `~~text~~` |

**Usage Example:**

```
Type: bold<Tab>
Result: **|**  (cursor positioned between asterisks)
```


### Code Blocks

| Snippet    | Trigger             | Result                   |
| ---------- | ------------------- | ------------------------ |
| Code Block | `codeblock` or `cb` | Code fence with language |

**Example:**

````
Type: cb<Tab>
Result:
```javascript
|
````

```

### Links and Images

| Snippet | Trigger | Result |
|---------|---------|---------|
| Link | `link` or `url` | `[text](url)` |
| Image | `image` or `img` | `![alt text](image_url)` |

### Tables

| Snippet | Trigger | Result |
|---------|---------|---------|
| Table | `table` | 3-column table with headers |

**Example:**
```

Type: table<Tab>
Result:
| Column1 | Column2 | Column3 |
| ------- | ------- | ------- |
| Row1Col1| Row1Col2| Row1Col3|
| Row2Col1| Row2Col2| Row2Col3|

````

## Key Bindings

Your Neovim setup includes these useful keybindings (leader = `<space>`):

### File Navigation
- `<leader>f` - Find files with Telescope
- `<leader>F` - Find all files (including ignored)
- `<leader>/` - Live grep search
- `<leader>h` - Recent files

### Text Editing
- `<leader>w` - Save file
- `jj` - Escape to normal mode
- `;;` - Add semicolon at end of line (insert mode)
- `,,` - Add comma at end of line (insert mode)

### Text Manipulation
- `J`/`K` (visual mode) - Move selected text up/down
- `<leader>j`/`<leader>k` - Move current line up/down
- `H`/`L` - Go to start/end of line

### Formatting
- `<leader>p` - Format current file with LSP
- `<leader>'` - Surround word/selection with single quotes
- `<leader>"` - Surround word with double quotes

### LSP Features
- `K` - Show hover documentation
- `gd` - Go to definition
- `gr` - Find references
- `<leader>ca` - Code actions
- `<leader>rn` - Rename symbol

## Live Preview

Your setup includes `markdown-preview.nvim` for real-time preview in your browser.

### Starting Preview
```vim
:MarkdownPreview
````

### Stopping Preview

```vim
:MarkdownPreviewStop
```

### Toggle Preview

```vim
:MarkdownPreviewToggle
```

**Pro Tip:** Add this to your keymaps for quick access:

```lua
keymap("n", "<leader>mp", "<cmd>MarkdownPreview<CR>", { desc = "Markdown Preview" })
```

## Workflow Examples

### Daily Note Taking

1. **Create a new note:**

   ```bash
   nvim notes/$(date +%Y-%m-%d).md
   ```

2. **Start with a template:**

   ```markdown
   # Notes for $(date +%Y-%m-%d)

   ## Tasks

   - [ ] Task 1
   - [ ] Task 2

   ## Notes

   ## Links
   ```

3. **Use snippets for quick formatting:**
   - Type `table<Tab>` for quick tables
   - Type `cb<Tab>` for code blocks
   - Type `link<Tab>` for references

### Documentation Writing

1. **Start with outline:**

   ```markdown
   # Project Documentation

   ## Overview

   ## Installation

   ## Usage

   ## Examples
   ```

2. **Use live preview:**
   - `:MarkdownPreview` to see formatting
   - Make changes and see them update in real-time

3. **Add code examples:**
   ```
   cb<Tab>bash<Tab>
   npm install package-name
   ```

### Meeting Notes

1. **Template setup:**

   ```markdown
   # Meeting: Project Review

   **Date:** 2024-01-15
   **Attendees:** Name1, Name2

   ## Agenda

   ## Discussion

   ## Action Items

   - [ ] Person: Task description

   ## Next Steps
   ```

## Advanced Tips

### Folding

Markdown files support folding based on headers:

- `za` - Toggle fold at cursor
- `zR` - Open all folds
- `zM` - Close all folds

### Search and Replace

- `<leader>sw` - Replace word under cursor globally
- Visual select text + `<leader>sw` - Replace selection

### Buffer Management

- `<leader>b` - Find open buffers
- `<leader>bd` - Delete current buffer
- `<leader>bo` - Close all buffers except current

### Quick Edits

- `ciw` - Change inner word
- `ci"` - Change inside quotes
- `ca"` - Change around quotes (includes quotes)

### Custom Markdown Workflows

#### Task Lists

```markdown
- [x] Completed task
- [ ] Pending task
- [!] Important task
- [ ] Another task to do
```

- [ ] Another Task
- [x] A Completed Item
- [x] Another thing done
- [x] Do some work
- [ ] Do more work
- [ ] More stuff
- [ ] Hi there
- [ ] Slimy



#### Definition Lists

```markdown
Term 1
: Definition 1

Term 2
: Definition 2
```

#### Footnotes

```markdown
This is a sentence with a footnote[^1].

[^1]: This is the footnote content.
```

### Vim-Specific Markdown Features

#### Automatic List Continuation

When you're in a list and press Enter, Neovim automatically continues the list:

```markdown
- Item 1
- Item 2 <-- Cursor here, press Enter
- | <-- Automatically adds bullet point
```

- A thing in my list
    - Does not seem to add the next item


#### Smart Indentation

Use `>` and `<` in visual mode to indent/outdent list items:

```markdown
- Level 1
  - Level 2 <-- Select and press < to outdent
- Level 1 <-- Result
```

## Export Options

### Using Pandoc (if installed)

```bash
# Convert to HTML
pandoc document.md -o document.html

# Convert to PDF (requires LaTeX)
pandoc document.md -o document.pdf

# Convert to Word
pandoc document.md -o document.docx

# Convert with custom CSS
pandoc document.md -c style.css -s -o document.html
```

### Using Markdown Preview

The preview plugin can export to HTML:

1. Open preview with `:MarkdownPreview`
2. In browser, right-click → "Save As" or print to PDF

### GitHub Integration

For documents going to GitHub:

```bash
# Preview exactly as GitHub renders
pandoc document.md --github-flavored-markdown -o preview.html
```

## Troubleshooting

### Preview Not Working

1. Check if you have a browser installed
2. Try `:MarkdownPreviewStop` then `:MarkdownPreview`
3. Check the plugin is loaded: `:PlugStatus` or `:PackerStatus`

### Syntax Highlighting Issues

1. Ensure Treesitter is installed: `:TSInstall markdown`
2. Check syntax: `:set syntax=markdown`

### Snippets Not Working

1. Verify you're in insert mode
2. Type the trigger exactly (case-sensitive)
3. Press Tab (not Enter)

### LSP Not Working

1. Restart LSP: `:LspRestart`
2. Check LSP status: `:LspInfo`

## Next Steps

1. **Practice the snippets** - Use them daily until they become muscle memory
2. **Customize keybindings** - Add your own shortcuts to `keymaps.lua`
3. **Explore plugins** - Consider `vim-table-mode` for advanced table editing
4. **Create templates** - Set up skeleton files for common document types

## Additional Resources

- `:help markdown` - Neovim's built-in markdown help
- `:help snippets` - Learn about extending snippets
- [Markdown Guide](https://www.markdownguide.org/) - Comprehensive markdown reference
- [Pandoc Manual](https://pandoc.org/MANUAL.html) - Advanced conversion options

---

_This guide is part of your development environment documentation. Update it as you discover new workflows and techniques!_
